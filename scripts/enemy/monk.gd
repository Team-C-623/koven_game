extends CharacterBody3D

@onready var player_3d=$"../Player"
@export var SPEED: float = 1.0
@export var CHASE_SPEED: float = 2.0
@export var ACCELERATION: float = 2.0
@export var CHASE_DISTANCE: float = 10.0  # Distance at which the enemy starts chasing
@export var gravity: float = 9.8

@onready var sprite: Sprite3D = $Sprite3D
#@onready var ray_cast: RayCast3D = $Sprite3D/RayCast3Ds

var direction: Vector3
var right_bounds: Vector3
var left_bounds: Vector3
var attack_damage:= 10.0

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
	
#func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body.is_in_group("Player Groups"):
		##print("Player entered attack range")
		#health_timer.start()
#
#func _on_area_3d_body_exited(body: Node3D) -> void:
	#if body.is_in_group("Player Groups"):
		##print("Player exited attack range")
		#health_timer.stop()
		#
#func _on_health_timer_timeout() -> void:
	#progress.value -= 10
	
func _on_hitbox_component_area_entered(area: Area3D) -> void:
	if area is HitboxComponent:
		print("Enemy hitbox entered")
		var hitbox : HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		hitbox.damage(attack)
