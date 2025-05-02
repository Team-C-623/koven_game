extends CharacterBody3D

class_name Player
@onready var wand = $head/PlayerCam/Wand
@export var attack_damage = 0.0
#camera settings
const SENS = 0.4
@export var speed = 3.0 #3.0
@export var inventory_data: InventoryData
@onready var inventory_interface: Control = get_node("/root/UIManager/InventoryInterface")
signal toggle_inventory()
@onready var rtpc_node: AkEvent3D = $rtpc
var enemies = []

@onready var interact_ray: RayCast3D = $InteractRay
@export var rtpc:WwiseRTPC
#var health: int = 100
var gravity: float = 9.8

# Stun variables
var is_stunned: bool = false
var stun_duration: float = 0.0

@export var journal: Journal
#bob variable
const BOB_FREQ = 2.0 #2.0
const BOB_AMP = 0.08 #0.08
var t_bob = 0.0

#FOV variable
const BASE_FOV = 90.0
const FOV_CHANGE = 1.5
@onready var health_component: HealthComponent = $HealthComponent

#Flame
var flame = load("res://weapons/Flame.tscn")
var instance

@onready var cam_mount = $head
@onready var camera = $head/PlayerCam
@onready var wand_anim = $head/PlayerCam/Wand/AnimationPlayer
@onready var wand_tip = $head/PlayerCam/Wand/RayCast3D
@onready var journal_ui = get_node("/root/UIManager/Journal_UI")
var was_rising := false  # Tracks previous frame's motion direction
var footstep_cooldown := 0.0  # Prevents double-triggering

func _ready() -> void:
	PlayerManager.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inventory_data = InventoryData.new()
	Wwise.set_state("PLAYER_STATE", "ALIVE")


	
func _unhandled_input(event: InputEvent) -> void:
	# "ui_cancel" is escape by default
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			# weird bug occurs if you try to rotate camera using mouse x and y movement
			# rotates camera mount node's y angle by mouse x movement
			cam_mount.rotate_y(-event.relative.x * SENS * 0.005)
			# rotates camera node's y angle by mouse y movement
			camera.rotate_x(-event.relative.y * SENS * 0.005)
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
		

	
func _physics_process(_delta: float) -> void:
	rtpc.set_value(rtpc_node,health_component.health)

	if !is_on_floor():
		velocity.y -= gravity * _delta
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (cam_mount.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	# Head bob
	t_bob += _delta * velocity.length() * float(is_on_floor()) 
	var new_head_pos = _headbob(t_bob)
	# Detect downward motion
	var is_rising = new_head_pos.y > camera.transform.origin.y

	
	# Play sound at peak descent (when switching from falling to rising)
	if was_rising and not is_rising and footstep_cooldown <= 0:
		SoundManager.play_footsteps()
		footstep_cooldown = 0.0  # Small cooldown to prevent double sounds
	
	# Update tracking variable
	was_rising = is_rising
	camera.transform.origin = new_head_pos
	footstep_cooldown = max(0, footstep_cooldown - _delta)
	#FOV
	var target_fov = BASE_FOV + FOV_CHANGE
	camera.fov = lerp(camera.fov, target_fov, _delta * 8.0)
		
	
	#Shooting 
	if Input.is_action_just_pressed("shoot") and !inventory_interface.visible and !ShopMenu.visible and !journal_ui.visible:
		#wand.shoot()
		if !wand_anim.is_playing():
			# Animation for shooting
			wand_anim.play("cast")
			instance = flame.instantiate()
			instance.position = wand_tip.global_position
			instance.transform.basis = wand_tip.global_transform.basis
			instance.attack_damage += attack_damage
			get_parent().add_child(instance)
			SoundManager.play_wand_sound()

	move_and_slide()
	
func _process(delta: float) -> void:
	#rtpc.set_value(rtpc_node,health_component.health)
	#Wwise.set_rtpc_value("Health", PlayerManager.player.health_component.health,self)
	var player = get_node("/root/Main/Player")  # Adjust path to your player node
	var combat_engaged = false
	
	# Check all enemies in parent node
	for node in get_parent().get_children():
		if node is Nun or node is Monk:  # Your enemy types
			if player.global_position.distance_to(node.global_position) < 3:  # 300 pixels range
				combat_engaged = true
				break  # Exit loop early if we found at least one nearby enemy

	# Set Wwise switch based on combat status
	if combat_engaged:
		Wwise.set_switch("GAMEPLAY_SWITCH", "COMBAT", self)
		SoundManager.play_enemy_aggro()
	else:
		Wwise.set_switch("GAMEPLAY_SWITCH", "EXPLORE", self)
		SoundManager.play_enemy_safe()

func get_drop_position() -> Vector3:
	var direction = -camera.global_transform.basis.z
	return camera.global_position + direction
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func stun(duration: float):
	if is_stunned:
		return
	
	is_stunned = true
	stun_duration = duration
	set_physics_process(false)
	
	await get_tree().create_timer(duration).timeout
	is_stunned = false
	set_physics_process(true)
	print("Player recovered from stun")
