extends Node3D

@onready var interact_area = $InteractPopup
@onready var dialogue_balloon = preload("res://dialogue/balloon.tscn").instantiate()

func _ready() -> void:
	interact_area.hide_popup()
	add_child(dialogue_balloon)
	dialogue_balloon.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interact_area.can_interact:
		interact()

func interact():
	dialogue_balloon.visible = true
	PlayerManager.is_talking_to_merga = true
	
	# just to make sure in case it was previously connected
	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_finished):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_finished)
		
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)
	DialogueManager.show_dialogue_balloon(load("res://catacombs/dialogue/merga.dialogue"), "start")
	
func _on_dialogue_finished(_result) -> void:
	dialogue_balloon.visible = false
	PlayerManager.is_talking_to_merga = false
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_finished)
