extends CharacterBody3D

#@export var player_3d: CharacterBody3D
@onready var player_3d=$"../Player"
@export var SPEED: float = 0.1
@export var CHASE_SPEED: float = 2.0
@export var ACCELERATION: float = 2.0
@export var CHASE_DISTANCE: float = 20.0  # Distance at which the enemy starts chasing

@onready var sprite: Sprite3D = $Sprite3D
@onready var ray_cast: RayCast3D = $Sprite3D/RayCast3D
@onready var timer = $Timer

var direction: Vector3
var right_bounds: Vector3
var left_bounds: Vector3

enum States{
	WANDER,
	CHASE
}

var current_state = States.WANDER

func _ready():
	pass


func _physics_process(delta: float) -> void:
	if player_3d == null:
		print("Player is not assigned!")
		return  # Exit if no player is assigned
		
	direction = (player_3d.position-position).normalized()
	var distance_to_player = position.distance_to(player_3d.position)
	
	# Switch to CHASE state if within chase range, otherwise WANDER
	if distance_to_player <= CHASE_DISTANCE:
		current_state = States.CHASE
	else:
		current_state = States.WANDER
	
	# Determine the velocity based on the state
	if current_state == States.CHASE:
		# Move towards the player at chase speed
		velocity = direction * CHASE_SPEED
	else:
		# Wander (you can add wandering logic if needed, for now just stay idle)
		velocity = direction * SPEED
	
	# Apply movement and slide
	move_and_slide()

	# Always face the player
	look_at(player_3d.position)
	
