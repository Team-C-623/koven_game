class_name Room extends StaticBody3D

@export var room_rotation: float = 0
@export var door_dict: Dictionary = {}
@export var room_type: String
@export var pos = Vector3(0, 0, 0)

const CHEST = preload("res://interactable/scenes/chest.tscn")
const JOURNAL_SPAWNER = preload("res://journal/scenes/journal_spawner.tscn")
const JOURNAL = preload("res://journal/scenes/journal.tscn")
const JOURNAL_CHANCE = 0.3

@onready var door_positions = $DoorPositions

func _ready():
	room_rotation = 0
	for child in door_positions.get_children():
		door_dict[child.name] = 0

func get_door_pos(door_pos):
	return door_positions.get_node(door_pos)

func create_chest():
	if room_type == "C":
		var chest_spawns = $ChestSpawns
		var chest_location = chest_spawns.get_children().pick_random()
		var new_chest = CHEST.instantiate()
		get_tree().get_current_scene().add_child(new_chest)
		new_chest.global_position = chest_location.global_position

func create_journal():
	if room_type == "EJ":
		if randf() <= JOURNAL_CHANCE:
			var new_journal = JOURNAL.instantiate()
			get_tree().get_current_scene().add_child(new_journal)
			var random_pos = Vector3(
				randf_range(-2, 2),
				0.5,
				randf_range(-2, 2)
			) + self.global_position
			new_journal.global_position = random_pos

func _spawn_journals_in_room():
	var spawners = find_children("*", "JournalSpawner", true)
	print(spawners)
	for spawner in spawners:
		spawner.try_spawn_journal()
