extends Node3D

@onready var interact_area = $InteractPopup
@onready var dialogue_balloon = preload("res://dialogue/balloon.tscn").instantiate()
@onready var old_witch_sprite: AnimatedSprite3D = $Sprite3D

func _ready() -> void:
	interact_area.hide_popup()
	add_child(dialogue_balloon)
	dialogue_balloon.visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interact_area.can_interact:
		interact()

func interact() -> void:
	old_witch_sprite.play("talk")
	Wwise.set_state("CATACOMB_WITCHES", "WITCH1")
	dialogue_balloon.visible = true
	PlayerManager.is_talking_to_old_witch = true
	
	# just to make sure in case it was previously connected
	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_finished):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_finished)
		
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)
	DialogueManager.show_dialogue_balloon(load("res://catacombs/dialogue/soulmother.dialogue"), "start")

func _on_dialogue_finished(_result) -> void:
	old_witch_sprite.stop()
	dialogue_balloon.visible = false
	PlayerManager.is_talking_to_old_witch = false
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_finished)
	Wwise.set_state("CATACOMB_WITCHES", "WITCH0")
