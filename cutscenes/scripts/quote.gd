extends CanvasLayer

func _ready():
	var balloon_scene = preload("res://cutscenes/scenes/quote_balloon.tscn")
	DialogueManager.show_dialogue_balloon_scene(balloon_scene, load("res://cutscenes/dialogue/intro_quote.dialogue"), "start")
