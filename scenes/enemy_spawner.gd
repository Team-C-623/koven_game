extends Node3D

const ENEMY = preload("res://scenes/enemy.tscn")

var current_enemy: CharacterBody3D = null  # Store reference to the spawned enemy

func _on_mob_timer_timeout() -> void:
	# new enemy instance 
	var enemy_spawn = ENEMY.instantiate()
	
	# random enemy spawn location
	enemy_spawn.global_position = global_position
	#
	## Spawn Radius
	#var spawn_radius = 10.0
	#
	## Random offset in radius
	#var random_offset = Vector3(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawner_position), 0)
	#
	## Enemy position
	#enemy_spawn.global_position = spawner_position + random_offset
	
	# Add enemy to scene
	get_parent().add_child(enemy_spawn)
	
