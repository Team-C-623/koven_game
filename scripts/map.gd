extends Node3D

# adds a room to the tree
func _add_room(room_scene):
	var new_instance = room_scene.instantiate()
	
	
	# add the new room to the tree
	add_child(new_instance)
	# return the room so that it can be used in subsequent room creations
	
	_spawn_journals_in_room(new_instance) #spawns journal
	return new_instance

#spawns keys
func _spawn_journals_in_room(room):
	var spawners = room.find_children("*", "JournalSpawner", true)
	for spawner in spawners:
		spawner.try_spawn_journal()
	
# sets the location of a provided room
func _set_room_position(new_instance, prev_room, prev_door_pos, new_door_pos):
	# sets the rotation of the new room to the provided rotation
	var prev_vect = _get_door_pos_vector(prev_door_pos)
	var new_vect = _get_door_pos_vector(new_door_pos)
	
	# calculates angle based on the previous room's rotation and the angle between the door position vectors
	var new_angle = prev_room.room_rotation - prev_vect.angle_to(new_vect) + PI
	
	# sets the rotation of the new room to the provided rotation
	new_instance.rotate_y(new_angle)
	# sets the new room's room_rotation variable to the new angle
	new_instance.room_rotation = new_angle
	
	new_instance.position = prev_room.get_node(prev_door_pos).global_position
		
	# linear algebra and trig method to get rotated rooms to match doors (blegh)
	# get x and z components from new room door position vector
	var x_coord = new_instance.get_node(new_door_pos).position[0]
	var z_coord = new_instance.get_node(new_door_pos).position[2]
	# get sine and cosine of the room's rotation angle
	var cos_rr = cos(new_instance.room_rotation)
	var sin_rr = sin(new_instance.room_rotation)
	new_instance.position -= Vector3(cos_rr * x_coord + sin_rr * z_coord, 0, cos_rr * z_coord - sin_rr * x_coord)

# adds a room to the tree and sets its location
# only used for testing stuff now, not in generate function
func _add_room_and_set(room_scene, prev_room, prev_door_pos, new_door_pos):
	var new_instance = room_scene.instantiate()
	
	# sets the rotation of the new room to the provided rotation
	var prev_vect = _get_door_pos_vector(prev_door_pos)
	var new_vect = _get_door_pos_vector(new_door_pos)
	
	# calculates angle based on the previous room's rotation and the angle between the door position vectors
	var new_angle = prev_room.room_rotation - prev_vect.angle_to(new_vect) + PI
	
	# sets the rotation of the new room to the provided rotation
	new_instance.rotate_y(new_angle)
	# sets the new room's room_rotation variable to the new angle
	new_instance.room_rotation = new_angle
	
	new_instance.position = prev_room.get_node(prev_door_pos).global_position
		
	# linear algebra and trig method to get rotated rooms to match doors (blegh)
	# get x and z components from new room door position vector
	var x_coord = new_instance.get_node(new_door_pos).position[0]
	var z_coord = new_instance.get_node(new_door_pos).position[2]
	# get sine and cosine of the room's rotation angle
	var cos_rr = cos(new_instance.room_rotation)
	var sin_rr = sin(new_instance.room_rotation)
	new_instance.position -= Vector3(cos_rr * x_coord + sin_rr * z_coord, 0, cos_rr * z_coord - sin_rr * x_coord)
	
	# add the new room to the tree
	add_child(new_instance)
	# return the room so that it can be used in subsequent room creations
	return new_instance

# returns a vector based on the given door position
func _get_door_pos_vector(door_pos):
	if door_pos == "DoorPosR":
		return Vector2(3, 0)
	elif door_pos == "DoorPosU":
		return Vector2(0, 3)
	elif door_pos == "DoorPosL":
		return Vector2(-3, 0)
	else:
		return Vector2(0, -3)
