extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	hide()
	animation_player.play("RESET")
	
func _process(_delta):
	pause_input()

func resume():
	SoundManager.play_menu_open()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	animation_player.play_backwards("blur")
	hide()

func pause():
	SoundManager.play_menu_open()
	get_tree().paused = true
	animation_player.play("blur")
	show()

func pause_input():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()
		
func _on_resume_button_pressed():
	SoundManager.play_menu_boop()
	resume()


func _on_guide_button_pressed():
	SoundManager.play_menu_boop()
	var guide_popup = preload("res://pause_menu/scenes/guide_popup.tscn").instantiate()
	add_child(guide_popup)

func _on_exit_button_pressed():
	SoundManager.play_menu_boop()
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
