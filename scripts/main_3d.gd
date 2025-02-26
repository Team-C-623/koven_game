extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var room2scene = preload("res://scenes/room2_3d.tscn")
	var room3scene = preload("res://scenes/room3_3d.tscn")
	var room4scene = preload("res://scenes/room4.tscn")
	var room5scene = preload("res://scenes/room5.tscn")
	
	var instance1 = _add_room(room2scene, null, null, "DoorPosD", 0, true)
	var instance2 = _add_room(room3scene, instance1, "DoorPosU", "DoorPosD", 0)
	var instance3 = _add_room(room2scene, instance2, "DoorPosL", "DoorPosD", 0.5*PI)
	var instance4 = _add_room(room3scene, instance3, "DoorPosU", "DoorPosL", PI)
	var instance5 = _add_room(room4scene, instance4, "DoorPosD", "DoorPosR", -0.5*PI)
	#var instance5 = _add_room(room5scene, instance4, "DoorPosU", "DoorPosD", 0)


func _add_room(room_scene, prev_room, prev_door_pos, new_door_pos, room_rotation, isFirstRoom=false):
	# creates a new instance of the given room
	var new_instance = room_scene.instantiate()
	# sets the rotation of the new room to the provided rotation
	new_instance.rotate_y(room_rotation)
	
	if isFirstRoom:
		# if this is the first room generated, get the position of the starting room's door and set the new room's position
		new_instance.position = get_node("room1_3d/DoorPos").global_position - new_instance.get_node(new_door_pos).position
	else:
		# otherwise, get the position of the requested door from the previous room and set the new room's position
		new_instance.position = prev_room.get_node(prev_door_pos).global_position

		# linear algebra and trig method to get rotated rooms to match doors (blegh)
		# get x and z components from new room door position vector
		var x_coord = new_instance.get_node(new_door_pos).position[0]
		var z_coord = new_instance.get_node(new_door_pos).position[2]
		# get sine and cosine of the room's rotation angle
		var cos_rr = cos(room_rotation)
		var sin_rr = sin(room_rotation)
		new_instance.position -= Vector3(cos_rr * x_coord + sin_rr * z_coord, 0, cos_rr * z_coord - sin_rr * x_coord)
	
	# add the new room to the tree
	add_child(new_instance)
	# return the room so that it can be used in subsequent room creations
	return new_instance
