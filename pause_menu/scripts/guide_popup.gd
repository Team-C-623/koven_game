extends CanvasLayer

func _on_back_button_pressed():
	SoundManager.play_menu_boop()
	queue_free()
