extends StaticBody3D

@export var room_rotation = 0
@export var door_dict = {}

func _ready():
	for child in self.get_children():
		if child.is_class("Marker3D"):
			door_dict[child.name] = 0
