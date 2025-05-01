extends Node2D

@onready var dialogue_balloon = preload("res://dialogue/balloon.tscn").instantiate()
@onready var dialogue_manager = DialogueManager
@onready var character_sprite: AnimatedSprite2D = $CanvasLayer2/Control/Character/AnimatedSprite2D
@onready var jury_sprite: TextureRect = $CanvasLayer/Control/TextureRect2
var pending_animation: String = ""

signal change_sprite(speaker_name: String)

func _ready() -> void:
	SoundManager.play_trial_room_music()
	add_child(dialogue_balloon)
	dialogue_balloon.visible = false
	character_sprite.animation_finished.connect(_on_animation_finished)
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
	var frames_path = ""
	var animation_to_play = "default"
	
	match speaker:
		"Judge Quétif":
			frames_path = "res://trialroom/animations/prosecutor_sprite.tres"
			animation_to_play = "default"
			jury_sprite.visible = true
		"Merga":
			frames_path = "res://trialroom/animations/merga_sprite.tres"
			animation_to_play = "shackle_drop"
			pending_animation = "talk"
			jury_sprite.visible = false
		"Player":
			frames_path = "res://trialroom/animations/mainwitch_sprite.tres"
			animation_to_play = "talk"
			jury_sprite.visible = false
		#"Soulmother":
			#sprite_path = "res://trialroom/art/soulmother.png"
	
	if frames_path != "":
		var new_frames = load(frames_path)
		if new_frames:
			character_sprite.frames = new_frames
			character_sprite.play(animation_to_play)


func _on_change_sprite(speaker_name: String):
	update_character_sprite(speaker_name)

func _on_animation_finished() -> void:
	if pending_animation != "":
		character_sprite.play(pending_animation)
		pending_animation = ""
