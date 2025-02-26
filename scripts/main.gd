extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# preload room scenes
	var room2scene = preload("res://scenes/room2.tscn")
	var room3scene = preload("res://scenes/room3.tscn")
	
	# add rooms to the tree
	var instance1 = _add_room(room2scene, null, null, 0, true)
	var instance2 = _add_room(room3scene, instance1, "DoorPos2", 0)
	var instance3 = _add_room(room2scene, instance2, "DoorPos2", -0.5*PI)
	var instance4 = _add_room(room3scene, instance3, "DoorPos2", -0.5*PI)
	var _instance5 = _add_room(room3scene, instance4, "DoorPos2", PI)


# adds a room to the tree
func _add_room(room_scene, prev_room, door_pos, room_rotation, isFirstRoom=false):
	# creates a new instance of the given room
	var new_instance = room_scene.instantiate()
	# sets the rotation of the new room to the provided rotation
	new_instance.rotation = room_rotation
	if isFirstRoom:
		# if this is the first room generated, get the position of the starting room's door and set the new room's position
		new_instance.global_position = get_node("room1/DoorPos1").global_position - new_instance.get_node("DoorPos1").global_position
	else:
		# otherwise, get the position of the requested door from the previous room and set the new room's position
		new_instance.global_position = prev_room.get_node(door_pos).global_position - new_instance.get_node("DoorPos1").global_position
	# add the new room to the tree
	add_child(new_instance)
	# return the room so that it can be used in subsequent room creations
	return new_instance
