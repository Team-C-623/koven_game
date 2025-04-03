extends Node3D

# imports rooms as packed scenes
var room1scene = preload("res://scenes/Rooms/room1.tscn")
var room2scene = preload("res://scenes/Rooms/room2.tscn")
var room3scene = preload("res://scenes/Rooms/room3.tscn")
var room4scene = preload("res://scenes/Rooms/room4.tscn")
var room5scene = preload("res://scenes/Rooms/room5.tscn")

const ROOMS_LIST = preload("res://resources/rooms_list.tres")

# creates a list of the options for rooms to choose from when generating
var room_options = {2: room2scene, 3: room3scene, 4: room4scene, 5: room5scene}

var new_room_options: Array[String] = ["room2", "room3", "room4", "room5"]

# creates a grid to store room positions
var room_grid = []

# generates a set of rooms
func generate(base_path_length):
	var prev_room = null
	
	# populates room grid with null values
	room_grid = []
	for i in range(2 * base_path_length + 1):
		var new_row = []
		for j in range(2 * base_path_length + 1):
			new_row.append(null)
		room_grid.append(new_row)
	
	for i in range(base_path_length):
		# if at 0, make the previous room the starting room
		if i == 0:
			prev_room = _add_first_room(room1scene)
			# godot has no integer division
			room_grid[base_path_length][base_path_length] = prev_room
		# pick a random room packed scene from the list of preloaded rooms
		var room_choice = room_options.keys()[randi() % room_options.size()]
		var room_type = room_options[room_choice]
		
		# add the new room to the tree
		var new_room = _add_room(room_type)
		
		# get random door choices from the dictionary for the previous and new rooms
		var prev_door_choice = prev_room.door_dict.keys()[randi() % prev_room.door_dict.size()]
		# check to make sure randomly chosen door is not already in use
		while prev_room.door_dict[prev_door_choice] != 0:
			prev_door_choice = prev_room.door_dict.keys()[randi() % prev_room.door_dict.size()]
		var new_door_choice = new_room.door_dict.keys()[randi() % new_room.door_dict.size()]
		# set used doors to 1 in the room's door dictionary
		prev_room.door_dict[prev_door_choice] = 1
		new_room.door_dict[new_door_choice] = 1
		
		# set the position of the room based on the chosen doors
		_set_room_position(new_room, prev_room, prev_door_choice, new_door_choice)
		# set the previous room to the newly created room to reiterate
		prev_room = new_room

func new_generate(base_path_length):
	var prev_room = null
	
	room_grid = []
	for i in range(2 * base_path_length + 1):
		var new_row = []
		for j in range(2 * base_path_length + 1):
			new_row.append(null)
		room_grid.append(new_row)
	
	prev_room = room1scene.instantiate()
	prev_room.room_rotation = 0
	room_grid[base_path_length][base_path_length] = prev_room
	var prev_room_space = Vector2(base_path_length, base_path_length)
	print(prev_room_space)
	add_child(prev_room)
	
	for i in range(5):
		var all_doors_blocked = true
		while all_doors_blocked:
			var room_choice = room_options.keys()[randi() % room_options.size()]
			var room_type = room_options[room_choice]
			var new_room = room_type.instantiate()
			add_child(new_room)
			
			var prev_door_choice = prev_room.door_dict.keys()[randi() % prev_room.door_dict.size()]
			var vect_to_check = _door_pos_to_grid_vect(prev_door_choice)
			var grid_to_check = prev_room_space + vect_to_check.rotated(prev_room.room_rotation)
			var timeout = false
			var iter = 0
			while prev_room.door_dict[prev_door_choice] != 0 and room_grid[grid_to_check[0]][grid_to_check[1]] != null and not timeout:
				prev_door_choice = prev_room.door_dict.keys()[randi() % prev_room.door_dict.size()]
				vect_to_check = _door_pos_to_grid_vect(prev_door_choice)
				grid_to_check = prev_room_space + vect_to_check.rotated(prev_room.room_rotation)
				iter += 1
				if iter > 10:
					timeout = true
			
			var new_door_choice = new_room.door_dict.keys()[randi() % new_room.door_dict.size()]
			if not timeout:
				prev_room.door_dict[prev_door_choice] = 1
				new_room.door_dict[new_door_choice] = 1
				
				#new_pos = old_pos + 1 rotated by old_door_pos
				for door in new_room.door_dict:
					var converted_space = _door_pos_to_grid_vect(door)
					var prev_door_vect = _get_door_pos_vector(prev_door_choice)
					var new_vect = _get_door_pos_vector(new_door_choice)
					var converted_new = _door_pos_to_grid_vect(prev_door_choice)
					var new_angle = prev_room.room_rotation - prev_door_vect.angle_to(new_vect) + PI
					var next_room_space = prev_room_space + converted_new.rotated(prev_room.room_rotation)
					var door_to_check = next_room_space + converted_space.rotated(new_angle)
					door_to_check = Vector2(round(door_to_check[0]), round(door_to_check[1]))
					if room_grid[door_to_check[0]][door_to_check[1]] == null:
						all_doors_blocked = false
			
			if all_doors_blocked or timeout:
				new_room.queue_free()
			else:
				var prev_vect = _get_door_pos_vector(prev_door_choice)
				var new_vect = _get_door_pos_vector(new_door_choice)
				
				# calculates angle based on the previous room's rotation and the angle between the door position vectors
				var new_angle = prev_room.room_rotation - prev_vect.angle_to(new_vect) + PI
				new_room.room_rotation = new_angle
				var x_coord = new_room.get_node(new_door_choice).position[0]
				var z_coord = new_room.get_node(new_door_choice).position[2]
				# get sine and cosine of the room's rotation angle
				var cos_rr = cos(new_room.room_rotation)
				var sin_rr = sin(new_room.room_rotation)
				new_room.pos = prev_room.get_node(prev_door_choice).global_position
				new_room.pos -= Vector3(cos_rr * x_coord + sin_rr * z_coord, 0, cos_rr * z_coord - sin_rr * x_coord)
				var _door_vect = _get_door_pos_vector(prev_door_choice)
				var converted_new = _door_pos_to_grid_vect(prev_door_choice)
				var next_room_space = prev_room_space + converted_new.rotated(prev_room.room_rotation)
				room_grid[next_room_space[0]][next_room_space[1]] = new_room
				new_room.position = new_room.pos
				new_room.rotate_y(new_angle)
				print(next_room_space)
				prev_room = new_room
				prev_room_space = next_room_space
				
	_print_room_grid()

func new_new_generate(base_path_length):
	# assign the starting grid space to the center of the room grid
	var prev_gridspace = Vector2(base_path_length, base_path_length)
	
	# create empty room grid
	room_grid = []
	for i in range(2 * base_path_length + 1):
		var new_row = []
		for j in range(2 * base_path_length + 1):
			new_row.append(null)
		room_grid.append(new_row)
	
	# add first room
	var new_room = _create_room_data("room1")
	new_room.pos = prev_gridspace
	room_grid[prev_gridspace[0]][prev_gridspace[1]] = new_room
	
	# sets the previous room to the newly created room
	var prev_room = new_room
	_add_room_from_data(prev_room)
	
	var rooms_added = 0
	while rooms_added < base_path_length - 1:
		if rooms_added == base_path_length - 2:
			new_room = _create_room_data("room1")
		else:
			new_room = _create_room_data(new_room_options.pick_random())
		
		var prev_door_choice = _get_random_door(prev_room)
		var new_door_choice = _get_random_door(new_room)
		
		while prev_room.door_dict[prev_door_choice] != 0:
			prev_door_choice = _get_random_door(prev_room)
		
		var no_valid_doors = _get_valid_doors(new_room, prev_room, prev_door_choice, new_door_choice)
		print(no_valid_doors)
		if not no_valid_doors:
			# sets the chosen doors to 1 in the rooms' door dictionaries
			prev_room.door_dict[prev_door_choice] = 1
			new_room.door_dict[new_door_choice] = 1
			
			# gets door position vectors for both door choices
			var prev_vect = _new_get_door_pos_vector(prev_door_choice)
			var new_vect = _new_get_door_pos_vector(new_door_choice)
			
			# calculates angle based on the previous room's rotation and the angle between the door position vectors
			new_room.room_rotation = prev_room.room_rotation - prev_vect.angle_to(new_vect) + PI
			
			# gets the grid space for the new room
			var next_gridspace = (prev_gridspace + prev_vect.rotated(prev_room.room_rotation)).snapped(Vector2(1, 1))
			print(next_gridspace)
			
			# sets the position of the new room and sets the gridspace to the new room
			new_room.pos = next_gridspace
			room_grid[next_gridspace[0]][next_gridspace[1]] = new_room
			_add_room_from_data(new_room)
			
			prev_room = new_room
			prev_gridspace = next_gridspace
			
			rooms_added += 1
		else:
			# add backtracking here
			pass
	
	_print_room_grid()

func _get_valid_doors(room: RoomData, prev_room: RoomData, prev_door_choice, new_door_choice):
	var no_valid_doors = true
	print("prev door choice: ", prev_door_choice, " for: ", prev_room.room_name)
	print("new door choice: ", new_door_choice, " for: ", room.room_name)
	var prev_vect = _new_get_door_pos_vector(prev_door_choice)
	var new_vect = _new_get_door_pos_vector(new_door_choice)
	var new_angle = prev_room.room_rotation - prev_vect.angle_to(new_vect) + PI
	var next_gridspace = (prev_room.pos + prev_vect.rotated(prev_room.room_rotation)).snapped(Vector2(1, 1))
	print("New room grid space: ", next_gridspace)
	for door in room.door_dict:
		var new_door_vect =  _new_get_door_pos_vector(door)
		var door_to_check = (next_gridspace + new_door_vect.rotated(new_angle)).snapped(Vector2(1, 1))
		print("Checking door: ", door, " at position: ", door_to_check)
		if room.room_name == "room1" or room_grid[door_to_check[0]][door_to_check[1]] == null and door != new_door_choice:
			no_valid_doors = false
	return no_valid_doors

# creates a new RoomData object based on the name string provided
func _create_room_data(new_room_name):
	var new_room = RoomData.new()
	new_room.room_name = new_room_name
	var used_room = ROOMS_LIST.Rooms[0]
	for room in ROOMS_LIST.Rooms:
		if new_room_name == room.name:
			used_room = room
	new_room.room_scene = used_room.room_scene
	new_room.room_type = used_room.room_type
	new_room.room_rotation = 0
	for door in used_room.doors:
		new_room.door_dict[door] = 0
	return new_room

# adds a child to the scene tree based on the provided RoomData object
func _add_room_from_data(room: RoomData):
	var new_instance = room.room_scene.instantiate()
	add_child(new_instance)
	new_instance.room_rotation = room.room_rotation
	new_instance.door_dict = room.door_dict
	new_instance.room_type = room.room_type
	new_instance.pos = Vector3(6 * room.pos[1], 0, 6 * room.pos[0])
	new_instance.global_position = new_instance.pos
	new_instance.rotate_y(new_instance.room_rotation)
	return new_instance

# gets a random door from a room's door dictionary
func _get_random_door(room: RoomData):
	return room.door_dict.keys()[randi() % room.door_dict.size()]

# adds a room to the tree
func _add_room(room_scene):
	var new_instance = room_scene.instantiate()
	# add the new room to the tree
	add_child(new_instance)
	# return the room so that it can be used in subsequent room creations
	return new_instance
	
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

func _add_first_room(room_scene):
	var new_instance = room_scene.instantiate()
	
	# sets the room's room_rotation variable to 0
	new_instance.room_rotation = 0
	# sets the room's position to the origin
	new_instance.position = Vector3(0, 0, 0)
	
	# add the new room to the tree
	add_child(new_instance)
	# return the room so that it can be used in subsequent room creations
	return new_instance

func _clear_rooms():
	var room_list = self.get_children()
	for node in room_list:
		node.queue_free()

# returns a vector based on the given door position
func _get_door_pos_vector(door_pos):
	if door_pos == "DoorPosR":
		return Vector2(1, 0)
	elif door_pos == "DoorPosU":
		return Vector2(0, 1)
	elif door_pos == "DoorPosL":
		return Vector2(-1, 0)
	else:
		return Vector2(0, -1)


# returns a vector based on the given door position (but better)
func _new_get_door_pos_vector(door_pos):
	if door_pos == "R":
		return Vector2(0, 1)
	elif door_pos == "U":
		return Vector2(-1, 0)
	elif door_pos == "L":
		return Vector2(0, -1)
	else:
		return Vector2(1, 0)

func _door_pos_to_grid_vect(door_pos: String):
	var new_vect = _get_door_pos_vector(door_pos)
	return Vector2(-1 * new_vect[1], new_vect[0])

func _print_room_grid():
	for line in room_grid:
		var line_string = ""
		for item in line:
			if item == null:
				line_string = line_string + "- "
			else:
				line_string = line_string + "R "
		print(line_string)
