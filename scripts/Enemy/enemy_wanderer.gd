extends State
class_name EnemyWander

var wander_direction: Vector3
var wander_time: float = 0.0

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null



func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")

func randomize_variables():
	wander_time = randf_range(1.5, 4)
	if randi_range(0, 3) != 1:
		wander_direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))
	else:
		wander_direction = Vector3.ZERO

func enter():
	randomize_variables()

func process(delta: float):
	if wander_time < 0.0:
		randomize_variables()
	
	wander_time -= delta
	
	if enemy.global_position.distance_to(player.global_position) < enemy.CHASE_DISTANCE:
		if enemy is Monk:
			Transitioned.emit(self, "EnemyChase")
		elif enemy is Nun:
			#Transitioned.emit(self, "EnemyShoot")
			Transitioned.emit(self, "EnemyChase")

func physics_process(_delta: float):
	enemy.velocity = wander_direction * enemy.SPEED

	if not enemy.is_on_floor():
		#hi
		enemy.velocity += enemy.get_gravity()
