extends Control

@onready var start_button: TextureButton = $HBoxContainer/StartButton
@onready var guide_button: TextureButton = $HBoxContainer/GuideButton
@onready var credits_button: TextureButton = $HBoxContainer/CreditsButton

func _ready():
	PlayerManager.in_game = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#Wwise.set_state("LOCATION", "MAIN_MENU")
	#SoundManager.play_main_menu_music()

func _on_start_button_pressed():
	start_button.disabled = true
	SoundManager.play_menu_boop()
	await get_tree().create_timer(1.0).timeout
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var quote_scene_path = "res://cutscenes/scenes/quote.tscn"
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file(quote_scene_path)
	
func _on_exit_button_pressed():
	SoundManager.play_menu_boop()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

func _on_guide_button_pressed():
	guide_button.disabled = true
	SoundManager.play_menu_boop()
	var guide_scene = "res://start_screen/scenes/guide.tscn"
	get_tree().change_scene_to_file(guide_scene)

func _on_credits_button_pressed() -> void:
	var credits_scene = preload("res://credits/scenes/credits.tscn").instantiate()
	#credits_scene.ended.connect(_on_credits_ended)
	get_tree().current_scene.add_child(credits_scene)
