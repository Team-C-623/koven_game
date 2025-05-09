extends Node2D

@onready var dialogue_balloon = preload("res://dialogue/balloon.tscn").instantiate()
@onready var dialogue_manager = DialogueManager
@onready var map = get_node("/root/Main/Map")

func _ready():
	PlayerManager.is_in_boss_dialogue = true
	add_child(dialogue_balloon)
	dialogue_balloon.visible = false
	start_dialogue()

func start_dialogue():
	dialogue_balloon.visible = true
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)
	DialogueManager.show_dialogue_balloon(load("res://Boss2/dialogue/boss2_dialogue.dialogue"), "start")

func _on_dialogue_finished(_result):
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	PlayerManager.is_in_boss_room = true
	PlayerManager.is_in_boss_dialogue = false
	var boss_room = preload("res://rooms/scenes/bossroom_1_tp.tscn").instantiate()
	map.add_child(boss_room)
	boss_room.global_position = Vector3(0, 60, 0)
	var boss_room_spawn = boss_room.global_position + Vector3(0, 0, 4)
	PlayerManager.player.global_position = boss_room_spawn
	queue_free()
