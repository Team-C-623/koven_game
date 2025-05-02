extends Node3D

# imports door as packed scene
var door_scene = preload("res://rooms/scenes/door.tscn")
 
const ROOMS_LIST = preload("res://rooms/resources/rooms_list.tres")

var room_types: Array[String] = ["room_2e", "room_3e", "room_4e", "room_5e"]

# creates a grid to store room positions
var room_grid = []

# generates a set of rooms
func generate():
	# dictionary of weights per room
	var weight_dict = {"room_2e": 2, "room_3e": 2, "room_4e": 3, "room_5e": 2, "room_2c": 2, "room_3c": 2}
	# list of rooms to choose from
	var room_options: Array[String] = _create_room_list(weight_dict)
	_clear_rooms()
	var base_path = generate_base_path(room_options)
	var _side_result = generate_side_paths(base_path)
	_add_all_rooms()
	return room_options.size()

# generates the starting set of rooms
func generate_base_path(room_options: Array[String]):
	var grid_size = room_options.size()
	# assign the starting grid space to the center of the room grid
	var prev_gridspace = Vector2(grid_size, grid_size)
	
	# creates a list for storing rooms in the starting path
	var base_path_list = []
	
	# create empty room grid
	_initialize_room_grid(grid_size)
	
	# add first room
	var new_room = _create_room_data("room_1e")
	new_room.pos = prev_gridspace
	room_grid[prev_gridspace[0]][prev_gridspace[1]] = new_room
	base_path_list.append(new_room)
	
	# sets the previous room to the newly created room
	var prev_room = new_room
	
	# backtracking data variables
	var prev_prev_room = null
	var prev_prev_door_choice = null
	var prev_prev_gridspace = Vector2(grid_size, grid_size)
	
	var rooms_added = 1
	while rooms_added < grid_size:
		if rooms_added == grid_size - 1:
			# replace with boss room eventually
			new_room = _create_room_data("room_1e")
		else:
			new_room = _create_room_data(room_options.pick_random())
		
		# gets list of all valid doors for the previous room
		var valid_door_list = []
		for door in prev_room.door_dict:
			var vect_to_check = _get_door_pos_vector(door)
			var grid_to_check = prev_room.pos + vect_to_check.rotated(prev_room.room_rotation).snapped(Vector2(1, 1))
			if prev_room.door_dict[door] == 0 and room_grid[grid_to_check[0]][grid_to_check[1]] == null:
				valid_door_list.append(door)
		
		# picks random door from the valid door list
		var prev_door_choice = valid_door_list.pick_random()
		var new_door_choice = _get_random_door(new_room)
		
		var no_valid_doors = true
		var unused_doors = true
		
		if valid_door_list.size() > 0:
			var door_valid_dict = {}
			for door in new_room.door_dict:
				# gets door validity for all door options
				no_valid_doors = _get_door_validity(new_room, prev_room, prev_door_choice, new_door_choice)
				door_valid_dict[new_door_choice] = no_valid_doors
			new_door_choice = door_valid_dict.keys()[randi() % door_valid_dict.size()]
		else:
			# if all doors from the previous room are in use, set this to false
			unused_doors = false
		
		# gets door position vectors for both door choices
		var prev_vect = _get_door_pos_vector(prev_door_choice)
		var new_vect = _get_door_pos_vector(new_door_choice)
		
		# skips loop and attempts a new room if previous room's doors are all used
		if not unused_doors:
			continue
		# runs if valid doors exist for the new room
		elif not no_valid_doors:
			# sets the chosen doors to 1 in the rooms' door dictionaries
			prev_room.door_dict[prev_door_choice] = 1
			new_room.door_dict[new_door_choice] = 1
			
			# calculates angle based on the previous room's rotation and the angle between the door position vectors
			new_room.room_rotation = prev_room.room_rotation - prev_vect.angle_to(new_vect) + PI
			
			# gets the grid space of the new room
			var next_gridspace = (prev_gridspace + prev_vect.rotated(prev_room.room_rotation)).snapped(Vector2(1, 1))
			
			# sets the position of the new room and sets the grid space to the new room
			new_room.pos = next_gridspace
			room_grid[next_gridspace[0]][next_gridspace[1]] = new_room
			base_path_list.append(new_room)
			
			# updates backtracking data
			prev_prev_room = prev_room
			prev_prev_door_choice = prev_door_choice
			prev_prev_gridspace = prev_gridspace
			
			# sets the previous room variable and its grid space to the new room
			prev_room = new_room
			prev_gridspace = next_gridspace
			
			rooms_added += 1
		# runs if no valid doors are found for the new room
		else:
			# gets the grid space of the new room
			var next_gridspace = (prev_gridspace + prev_vect.rotated(prev_room.room_rotation)).snapped(Vector2(1, 1))
			
			# removes new and previous rooms from the grid
			room_grid[next_gridspace[0]][prev_gridspace[1]] = null
			room_grid[prev_gridspace[0]][prev_gridspace[1]] = null
			new_room = null
			
			# updates previous room variables
			prev_room = prev_prev_room
			prev_door_choice = prev_prev_door_choice
			prev_room.door_dict[prev_door_choice] = 0
			prev_gridspace = prev_prev_gridspace
			
			# subtracts from room count to maintain correct number
			rooms_added -= 1
	
	return base_path_list

func generate_side_paths(base_path):
	for room: RoomData in base_path:
		var valid_door_list = []
		# check if there are valid doors for the current room
		for door in room.door_dict:
			var vect_to_check = _get_door_pos_vector(door)
			var grid_to_check = room.pos + vect_to_check.rotated(room.room_rotation).snapped(Vector2(1, 1))
			if room.door_dict[door] == 0 and room_grid[grid_to_check[0]][grid_to_check[1]] == null:
				valid_door_list.append(door)
		if valid_door_list.size() > 0:
			# pick a random valid door from the previous room and get the next grid space
			var door_choice = valid_door_list.pick_random()
			var door_vect = _get_door_pos_vector(door_choice)
			var new_vect = _get_door_pos_vector("U")
			var room_gridspace = room.pos + door_vect.rotated(room.room_rotation).snapped(Vector2(1, 1))
			var new_room = _create_room_data("room_t")
			
			# update room attributes and grid to reflect room addition
			room.door_dict[door_choice] = 1
			new_room.door_dict["U"] = 1
			new_room.room_rotation = room.room_rotation - door_vect.angle_to(new_vect) + PI
			new_room.pos = room_gridspace
			room_grid[room_gridspace[0]][room_gridspace[1]] = new_room
			
			return true
	# return false if no valid rooms are found
	return false

# adds all rooms in the grid
func _add_all_rooms():
	for row in room_grid:
		for col in row:
			if col != null:
				var new_room = _add_room_from_data(col)
				for door_pos in new_room.door_dict.keys():
					if new_room.door_dict[door_pos] == 0:
						_create_new_door(new_room, door_pos)

# gets the validity of a room by its doors (a room with any doors available will return false)
func _get_door_validity(room: RoomData, prev_room: RoomData, prev_door_choice, new_door_choice):
	var no_valid_doors = true
	var prev_vect = _get_door_pos_vector(prev_door_choice)
	var new_vect = _get_door_pos_vector(new_door_choice)
	var new_angle = prev_room.room_rotation - prev_vect.angle_to(new_vect) + PI
	var next_gridspace = (prev_room.pos + prev_vect.rotated(prev_room.room_rotation)).snapped(Vector2(1, 1))
	
	for door in room.door_dict:
		var new_door_vect =  _get_door_pos_vector(door)
		var door_to_check = (next_gridspace + new_door_vect.rotated(new_angle)).snapped(Vector2(1, 1))
		
		# if a valid room exists, return false
		if room.room_name == "room_1e" or room_grid[door_to_check[0]][door_to_check[1]] == null and door != new_door_choice:
			no_valid_doors = false
	return no_valid_doors

# adds a new door to the map
func _create_new_door(new_room, door_pos):
	var new_door = door_scene.instantiate()
	add_child(new_door)
	var door_position = new_room.get_node(door_pos).global_position.snapped(Vector3(1, 1, 1))
	var door_rotation = new_room.room_rotation + _get_door_rotation(door_pos)
	
	#var rel_door_pos = (new_room.global_position - door_position).snapped(Vector3(1, 1, 1))
	#print(rel_door_pos, "\t", door_pos)
	#if rel_door_pos[0] == 0:
		#new_door.global_position = door_position - Vector3(0.01 * rel_door_pos[0], 0, 0.01 * rel_door_pos[1])
	#else:
		#new_door.global_position = door_position + Vector3(0.01 * rel_door_pos[0], 0, 0.01 * rel_door_pos[1])
	
	new_door.global_position = door_position
	new_door.rotate_y(door_rotation)

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
	new_instance.pos = Vector3(6.001 * room.pos[1], 0, 6.001 * room.pos[0])
	new_instance.global_position = new_instance.pos
	new_instance.rotate_y(new_instance.room_rotation)
	new_instance.create_chest()
	return new_instance

# gets a random door from a room's door dictionary
func _get_random_door(room: RoomData):
	return room.door_dict.keys()[randi() % room.door_dict.size()]

# removes all rooms from the scene tree
func _clear_rooms():
	var room_list = self.get_children()
	for node in room_list:
		node.queue_free()
	room_grid = []

# returns a grid vector based on the given door position
func _get_door_pos_vector(door_pos):
	if door_pos == "R":
		return Vector2(0, 1)
	elif door_pos == "U":
		return Vector2(-1, 0)
	elif door_pos == "L":
		return Vector2(0, -1)
	else:
		return Vector2(1, 0)

# returns a vector based on the door position in 3D space
func _get_3d_door_vector(door_pos):
	if door_pos == "R":
		return Vector2(1, 0)
	elif door_pos == "U":
		return Vector2(0, 1)
	elif door_pos == "L":
		return Vector2(-1, 0)
	else:
		return Vector2(0, -1)

# returns an angle based on the given door position
func _get_door_rotation(door_pos):
	if door_pos == "U" or door_pos == "D":
		return 0
	else:
		return PI/2

func _create_room_list(rooms_dict: Dictionary):
	var room_list: Array[String] = []
	for room in rooms_dict.keys():
		for i in range(rooms_dict[room]):
			room_list.append(room)
	return room_list

# creates the room grid based on the given path size
func _initialize_room_grid(base_path_length):
	room_grid = []
	for i in range(2 * base_path_length + 1):
		var new_row = []
		for j in range(2 * base_path_length + 1):
			new_row.append(null)
		room_grid.append(new_row)

# prints the room grid in a readable format
func _print_room_grid():
	for line in room_grid:
		var line_string = ""
		for item in line:
			if item == null:
				line_string = line_string + "- "
			else:
				line_string = line_string + "R "
		print(line_string)
