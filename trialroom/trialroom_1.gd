extends Node2D

@onready var dialogue_balloon = preload("res://dialogue/balloon.tscn").instantiate()
@onready var dialogue_manager = DialogueManager
@onready var character_sprite: Sprite2D = $CanvasLayer2/Control/Character/Sprite2D

func _ready() -> void:
	add_child(dialogue_balloon)
	dialogue_balloon.visible = false
	
	start_dialogue()

func start_dialogue():
	dialogue_balloon.visible = true
	DialogueManager.show_dialogue_balloon(load("res://trialroom/dialogue/trial1.dialogue"), "start")
