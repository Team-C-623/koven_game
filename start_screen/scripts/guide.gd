extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_back_button_pressed():
	SoundManager.play_menu_boop()
	get_tree().change_scene_to_file("res://start_screen/scenes/start_screen.tscn")
