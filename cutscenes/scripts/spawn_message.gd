extends CanvasLayer

func _ready():
	var balloon_scene = preload("res://cutscenes/scenes/quote_balloon.tscn")
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)
	DialogueManager.show_dialogue_balloon_scene(balloon_scene, load("res://cutscenes/dialogue/spawn_message.dialogue"), "start")

func _on_dialogue_finished(_result):
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	PlayerManager.in_game = true
	get_tree().change_scene_to_file("res://main/scenes/main.tscn")
