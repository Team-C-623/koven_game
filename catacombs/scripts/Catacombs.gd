extends StaticBody3D
var shop_witch_scene = preload("res://catacombs/scenes/shop_witch.tscn")
var old_witch_scene = preload("res://catacombs/scenes/old_witch.tscn")

func _ready() -> void:
	PlayerManager.merga_saved.connect(_on_merga_saved)
	var new_old_witch = old_witch_scene.instantiate()
	add_child(new_old_witch)
	new_old_witch.position = Vector3(-2, 0, -4.5)
	Wwise.set_state("LOCATION", "CATACOMBS")
	SoundManager.play_start_music()
	#SoundManager.play_respawn()

func _on_merga_saved() -> void:
	if PlayerManager.has_saved_merga:
		if not has_node("ShopWitch"):
			var new_shop_witch = shop_witch_scene.instantiate()
			add_child(new_shop_witch)
			new_shop_witch.position = Vector3(-9.5, 0, 0)
			new_shop_witch.position = Vector3(-2, 0, 4.5)
	else:
		if has_node("ShopWitch"):
			get_node("ShopWitch").queue_free()
