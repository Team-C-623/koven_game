extends StaticBody3D
var shop_witch_scene = preload("res://catacombs/scenes/shop_witch.tscn")
var old_witch_scene = preload("res://catacombs/scenes/old_witch.tscn")

func _ready() -> void:
	var new_old_witch = old_witch_scene.instantiate()
	add_child(new_old_witch)
	new_old_witch.position = Vector3(-2, 0, -4.5)
	var new_shop_witch = shop_witch_scene.instantiate()
	add_child(new_shop_witch)
	new_shop_witch.position = Vector3(-9.5, 0, 0)
	new_shop_witch.position = Vector3(-2, 0, 4.5)
	SoundManager.play_start_music()
