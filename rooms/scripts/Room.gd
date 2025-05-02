class_name Room extends StaticBody3D

@export var room_rotation = 0
@export var door_dict = {}
@export var room_type: String
@export var pos = Vector3(0, 0, 0)

const CHEST = preload("res://interactable/scenes/chest.tscn")

func _ready():
	room_rotation = 0
	for child in self.get_children():
		if child.is_class("Marker3D"):
			door_dict[child.name] = 0

func create_chest():
	if room_type == "C":
		print("creating chest")
		var chest_spawns = $ChestSpawns
		var chest_location = chest_spawns.get_children().pick_random()
		var new_chest = CHEST.instantiate()
		get_tree().get_current_scene().add_child(new_chest)
		new_chest.global_position = chest_location.global_position
