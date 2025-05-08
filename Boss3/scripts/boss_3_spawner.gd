extends Node3D

@onready var spawn_timer = $spawnTimer

const MONK = preload("res://enemy/scenes/monk.tscn")
const NUN = preload("res://enemy/scenes/nun.tscn")

var spawn_index := 0
var spawn_list = [MONK, NUN]

func _ready():
	spawn_timer.start()

func _on_spawn_timer_timeout():
	var enemy_scene = spawn_list[spawn_index % spawn_list.size()]
	spawn_index += 1
	
	var new_enemy = enemy_scene.instantiate()
	get_tree().current_scene.add_child(new_enemy)
	
	var forward = -global_transform.basis.z.normalized() # forward direction
	new_enemy.global_position = global_position + forward * 1.0
		
