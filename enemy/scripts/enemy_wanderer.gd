extends State
class_name EnemyWander

var wander_direction: Vector3
var wander_time: float = 0.0

@onready var enemy: CharacterBody3D = get_parent().get_parent()
@onready var ray_cast_3d: RayCast3D = enemy.get_node("RayCast3D")
var player: CharacterBody3D = null

func _ready() -> void:
	Wwise.set_switch("GAMEPLAY_STATE", "EXPLORE", self)
	player = get_tree().get_first_node_in_group("Player Groups")
	#if Global.player:
		#player = Global.player
	#else:
		#print("Player not found")
	

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
	
	if is_instance_valid(player) and enemy.global_position.distance_to(player.global_position) < enemy.CHASE_DISTANCE:
		#ray_cast_3d.cast_to = player.global_position - enemy.global_position
		ray_cast_3d.force_raycast_update()
		if not ray_cast_3d.is_colliding() or ray_cast_3d.get_collider() == player:
			if enemy is Monk:
				Transitioned.emit(self, "EnemyChase")
			elif enemy is Nun:
				Transitioned.emit(self, "EnemyShoot")

func physics_process(_delta: float):
	enemy.velocity = wander_direction * enemy.SPEED
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity()
