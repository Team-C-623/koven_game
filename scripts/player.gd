extends CharacterBody3D

@onready var wand = $head/PlayerCam/Wand

#attack settings
var attack_damage := 10.0

#camera settings
const SENS = 0.4
const SPEED = 5.0

#bob variable
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

#FOV variable
const BASE_FOV = 90.0
const FOV_CHANGE = 1.5

#Flame
var flame = load("res://weapons/Flame.tscn")
var instance

@onready var cam_mount = $head
@onready var camera = $head/PlayerCam
@onready var wand_anim = $head/PlayerCam/Wand/AnimationPlayer
@onready var wand_tip = $head/PlayerCam/Wand/RayCast3D

func _unhandled_input(event: InputEvent) -> void:
	# allows mouse lock and unlock
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# "ui_cancel" is escape by default
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			# weird bug occurs if you try to rotate camera using mouse x and y movement
			# rotates camera mount node's y angle by mouse x movement
			cam_mount.rotate_y(-event.relative.x * SENS * 0.005)
			# rotates camera node's y angle by mouse y movement
			camera.rotate_x(-event.relative.y * SENS * 0.005)

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (cam_mount.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	# Head bob
	t_bob += _delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var target_fov = BASE_FOV + FOV_CHANGE
	camera.fov = lerp(camera.fov, target_fov, _delta * 8.0)
	
	##Shooting 
	if Input.is_action_just_pressed("shoot"):
		#wand.shoot()
		if !wand_anim.is_playing():
			# Animation for shooting
			wand_anim.play("cast")
			instance = flame.instantiate()
			instance.position = wand_tip.global_position
			instance.transform.basis = wand_tip.global_transform.basis
			get_parent().add_child(instance)
			# actual damage
			var attack = Attack.new()
			attack.attack_damage = attack_damage

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
