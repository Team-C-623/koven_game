extends StaticBody3D

const MONK = preload("res://enemy/scenes/monk.tscn")
const MESH = preload("res://testing/wall_mesh.tscn")
const SPRITE = preload("res://testing/wall_sprite.tscn")
const DOOR = preload("res://testing/wall_door.tscn")

func _ready() -> void:
	create_doors()

func create_enemies() -> void:
	for i in range(100):
		var new_monk = MONK.instantiate()
		add_child(new_monk)
		new_monk.global_position = Vector3(10 * cos(i), 0, 10 * sin(i))
		
func create_meshes() -> void:
	for i in range(200):
		var new_wall = MESH.instantiate()
		add_child(new_wall)
		new_wall.global_position = Vector3(10 * cos(i), 0, 10 * sin(i))
		
func create_sprites() -> void:
	for i in range(200):
		var new_wall = SPRITE.instantiate()
		add_child(new_wall)
		new_wall.global_position = Vector3(10 * cos(i), 0, 10 * sin(i))
		
func create_doors() -> void:
	for i in range(200):
		var new_door = DOOR.instantiate()
		add_child(new_door)
		new_door.global_position = Vector3(10 * cos(i), 0, 10 * sin(i))
