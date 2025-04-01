extends Node3D

@onready var enemy_scene = preload("res://scenes/enemy_spawner.tscn")

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	##spawn_enemy()
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.position = position
	get_parent().add_child(enemy)

	
