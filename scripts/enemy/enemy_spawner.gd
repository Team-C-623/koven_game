extends Node3D

const ENEMY = preload("res://scenes/enemy/monk.tscn")
const ENEMY2 = preload("res://scenes/enemy/nun.tscn")

var player: CharacterBody3D
var spawn_radius: float = 3.0
var total_enemies: int = 3

func _ready():
	print("Spawner is ready at position: ", global_position)
	call_deferred("_start_spawning")

func _start_spawning():
	print("Starting spawn sequence...")
	player = get_tree().get_first_node_in_group("Player Groups")
	
	if player:
		print("Player found: ", player.name)
		spawn_enemies()
	else:
		print("⚠️ Player not found in group 'Player Groups'")

func spawn_enemies():
	print("Spawning ", total_enemies, " enemies...")
	for i in range(total_enemies):
		var enemy_scene = choose_random_enemy()
		var enemy_instance = enemy_scene.instantiate()
		print("Instantiated enemy #", i, ": ", enemy_instance)

		var offset = Vector3(
			randf_range(-spawn_radius, spawn_radius),
			0,
			randf_range(-spawn_radius, spawn_radius)
		)

		var spawn_position = global_position + offset
		enemy_instance.global_position = spawn_position
		print("Spawn position for enemy #", i, ": ", spawn_position)

		get_tree().get_current_scene().add_child(enemy_instance)
		print("Enemy #", i, " added to scene.")

func choose_random_enemy() -> PackedScene:
	# Weighted choice: 3 monks and 2 nuns
	var pool = [ENEMY, ENEMY, ENEMY, ENEMY2, ENEMY2]
	return pool[randi() % pool.size()]
