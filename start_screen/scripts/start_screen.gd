extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var quote_scene_path = "res://cutscenes/scenes/quote.tscn"
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file(quote_scene_path)
	
func _on_exit_button_pressed():
	get_tree().quit()

func _on_guide_button_pressed():
	var guide_scene = preload("res://start_screen/scenes/guide.tscn").instantiate()
	get_tree().current_scene.add_child(guide_scene)
