extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Wwise.set_state("LOCATION", "MAIN_MENU")
	PlayerManager.is_in_main_menu = true
	SoundManager.play_main_menu_music()

func _on_start_button_pressed():
	SoundManager.play_menu_boop()
	await get_tree().create_timer(1.0).timeout
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var quote_scene_path = "res://cutscenes/scenes/quote.tscn"
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file(quote_scene_path)
	
func _on_exit_button_pressed():
	SoundManager.play_menu_boop()
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

func _on_guide_button_pressed():
	SoundManager.play_menu_boop()
	var guide_scene = preload("res://start_screen/scenes/guide.tscn").instantiate()
	get_tree().current_scene.add_child(guide_scene)


func _on_credits_button_pressed() -> void:
	var credits_scene = preload("res://credits/scenes/credits.tscn").instantiate()
	credits_scene.ended.connect(_on_credits_ended)
	get_tree().current_scene.add_child(credits_scene)
	Wwise.set_state("LOCATION", "CREDITS")
	

func _on_credits_ended():
		Wwise.set_state("LOCATION", "MAIN_MENU")
		#get_tree().current_scene.get_node("credits").queue_free()
