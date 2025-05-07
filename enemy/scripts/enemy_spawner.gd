extends Node3D

const ENEMY = preload("res://enemy/scenes/monk.tscn")
const ENEMY2 = preload("res://enemy/scenes/nun.tscn")

var player: CharacterBody3D
var spawn_radius: float = 2.0
var total_enemies: int = 3

func _ready():
	call_deferred("_start_spawning")

func _start_spawning():
	player = get_tree().get_first_node_in_group("Player Groups")
	
	if player:
		spawn_enemies()
	else:
		print("⚠️ Player not found in group 'Player Groups'")

func spawn_enemies():
	for i in range(total_enemies):
		var enemy_scene = choose_random_enemy()
		var enemy_instance = enemy_scene.instantiate()

		var offset = Vector3(
			randf_range(-spawn_radius, spawn_radius),
			0,
			randf_range(-spawn_radius, spawn_radius)
		)

		var spawn_position = global_position + offset
		enemy_instance.global_position = spawn_position

		get_tree().get_current_scene().add_child(enemy_instance)

func choose_random_enemy() -> PackedScene:
	# Weighted choice: 3 monks and 2 nuns
	var pool = [ENEMY, ENEMY, ENEMY, ENEMY2, ENEMY2]
	return pool[randi() % pool.size()]
