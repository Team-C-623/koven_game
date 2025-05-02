extends CanvasLayer

func _ready():
	var balloon_scene = preload("res://cutscenes/scenes/quote_balloon.tscn").instantiate()
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)
	DialogueManager.show_dialogue_balloon_scene(balloon_scene, load("res://cutscenes/dialogue/intro_quote.dialogue"), "start")

func _on_dialogue_finished(result):
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://cutscenes/scenes/spawn_message.tscn")
