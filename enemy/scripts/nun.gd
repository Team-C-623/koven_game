extends CharacterBody3D
class_name Nun

# For enemy 2
@onready var player_3d = $"../Player"
@export var SPEED: float = 0.5
@export var CHASE_SPEED: float = 1.0
@export var ACCELERATION: float = 2.0
@export var CHASE_DISTANCE: float = 4.5  # Distance at which the enemy starts chasing
@export var gravity: float = 9.8
@export var is_ranged: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray: RayCast3D = $RayCast3D
@onready var sprite: Sprite3D = $Sprite3D

# i dont think this is ever used
#signal dying

var direction: Vector3
var right_bounds: Vector3
var left_bounds: Vector3
var attack_damage:= 3.0
var is_alerted := false

func _ready():
	ray.enabled = true
	await get_tree().process_frame
	await get_tree().process_frame
	player_3d = get_tree().get_first_node_in_group("Player Groups")

func _process(_delta):
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

func _on_health_component_nun_die() -> void:
	animation_player.stop()
	#dying.emit()
	animation_player.play("death")
	SoundManager.play_enemy_death()
	await animation_player.animation_finished
	queue_free()
	
func knife_effect_sound():
	SoundManager.play_nun_projectile()
