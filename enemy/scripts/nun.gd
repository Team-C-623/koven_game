extends CharacterBody3D
class_name Nun

# For enemy 2
@onready var player_3d=$"../Player"
@export var SPEED: float = 0.5
@export var CHASE_SPEED: float = 1.0
@export var ACCELERATION: float = 2.0
@export var CHASE_DISTANCE: float = 5.0  # Distance at which the enemy starts chasing
@export var gravity: float = 9.8
@export var is_ranged: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var sprite: Sprite3D = $Sprite3D
#@onready var ray_cast: RayCast3D = $Sprite3D/RayCast3Ds
signal dying
var direction: Vector3
var right_bounds: Vector3
var left_bounds: Vector3
var attack_damage:= 3.0

func _ready():
	pass

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

func _on_health_component_nun_die() -> void:
	animation_player.stop()
	#dying.emit()
	animation_player.play("death")
	SoundManager.play_enemy_death()
	await animation_player.animation_finished
	queue_free()
	
func knife_effect_sound():
	SoundManager.play_nun_projectile()
