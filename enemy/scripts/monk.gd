extends CharacterBody3D
class_name Monk

@onready var player_3d=$"../Player"
@export var SPEED: float = 0.5
@export var CHASE_SPEED: float = 1.0
@export var ACCELERATION: float = 2.0
@export var CHASE_DISTANCE: float = 5.0  # Distance at which the enemy starts chasing
@export var gravity: float = 9.8
@onready var health_component: HealthComponent = $HealthComponent
@onready var ray: RayCast3D = $RayCast3D
@onready var sprite: Sprite3D = $Sprite3D
@onready var damage_timer: Timer = $DamageTimer

var direction: Vector3
var right_bounds: Vector3
var left_bounds: Vector3
var attack_damage:= 2.0
var current_hitbox: HitboxComponent = null

func _ready():
	ray.enabled = true
	await get_tree().process_frame
	await get_tree().process_frame
	player_3d = get_tree().get_first_node_in_group("Player Groups")
	$HitboxComponent.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))
	$HitboxComponent.connect("area_exited", Callable(self, "_on_hitbox_area_exited"))
	$DamageTimer.connect("timeout", Callable(self, "_on_DamageTimer_timeout"))
	
func _process(delta):
	ray.force_raycast_update()

func _physics_process(delta: float) -> void:
	# Debugging
	if player_3d == null:
		return  # Exit if no player is assigned
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		
	move_and_slide()

	# Always face the player
	look_at(player_3d.position)

func _on_hitbox_area_entered(area: Area3D) -> void:
	if area is HitboxComponent:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		current_hitbox = area
		current_hitbox.damage(attack)
		damage_timer.start()

func _on_hitbox_area_exited(area: Area3D) -> void:
	if area == current_hitbox:
		current_hitbox = null
		damage_timer.stop()

func _on_DamageTimer_timeout():
	if current_hitbox:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		current_hitbox.damage(attack)
