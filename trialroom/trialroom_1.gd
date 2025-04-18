extends Node2D

@onready var dialogue_balloon = preload("res://dialogue/balloon.tscn").instantiate()
@onready var dialogue_manager = DialogueManager
@onready var character_sprite: Sprite2D = $CanvasLayer2/Control/Character/Sprite2D

signal change_sprite(speaker_name: String)

func _ready() -> void:
	add_child(dialogue_balloon)
	dialogue_balloon.visible = false
	
	start_dialogue()

func start_dialogue():
	dialogue_balloon.visible = true
	DialogueManager.mutated.connect(_on_mutation)
	DialogueManager.show_dialogue_balloon(load("res://trialroom/dialogue/trial1.dialogue"), "start")

func _on_mutation(mutation: Dictionary) -> void:
	if mutation.has("change_sprite"):
		var speaker = mutation["change_sprite"]
		emit_signal("change_sprite", speaker)

func update_character_sprite(speaker: String) -> void:
	var sprite_path = ""
	
	match speaker:
		"Judge Quétif":
			sprite_path = "res://trialroom/art/judge.png"
		"Merga":
			sprite_path = "res://trialroom/art/merga.png"
		"Player":
			sprite_path = "res://trialroom/art/mainwitch.png"
		"Soulmother":
			sprite_path = "res://trialroom/art/soulmother.png"
		_:
			sprite_path = "res://trialroom/art/mainwitch.png"
	
	if sprite_path != "":
		var new_texture = load(sprite_path)
		if new_texture:
			character_sprite.texture = new_texture


func _on_change_sprite(speaker_name: String):
	update_character_sprite(speaker_name)
