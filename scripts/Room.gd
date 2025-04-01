class_name Room extends StaticBody3D

@export var room_rotation = 0
@export var door_dict = {}
@export var room_type: int
@export var pos = Vector3(0, 0, 0)

func _ready():
	room_rotation = 0
	for child in self.get_children():
		if child.is_class("Marker3D"):
			door_dict[child.name] = 0
