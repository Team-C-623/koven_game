extends Node3D

# imports rooms as packed scenes
var room2scene = preload("res://scenes/Rooms/room2.tscn")
var room3scene = preload("res://scenes/Rooms/room3.tscn")
var room4scene = preload("res://scenes/Rooms/room4.tscn")
var room5scene = preload("res://scenes/Rooms/room5.tscn")

# creates a list of the options for rooms to choose from when generating
# probably a better way to do this? idk
var room_options = [room2scene, room3scene, room4scene, room5scene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate()
	
	# create a non-random room, adds it to the tree and then sets its position
	#var instance1 = get_node("Map")._add_room(room2scene)
	#get_node("Map")._set_room_position(instance1, get_node("Map/room1"), "DoorPosU", "DoorPosD")
	#var instance2 = get_node("Map")._add_room(room3scene)
	#get_node("Map")._set_room_position(instance2, instance1, "DoorPosU", "DoorPosD")
	
	# old method to create a room, adds to tree and sets position in the same method
	# basically more control is better
	#var instance1 = get_node("Map")._add_room_and_set(room5scene, get_node("Map/room1"), "DoorPosU", "DoorPosL")
	#var instance3 = get_node("Map")._add_room_and_set(room2scene, instance2, "DoorPosL", "DoorPosD")
	#var instance4 = get_node("Map")._add_room_and_set(room3scene, instance3, "DoorPosU", "DoorPosL")
	#var instance5 = get_node("Map")._add_room_and_set(room4scene, instance4, "DoorPosD", "DoorPosR")
	#var instance6 = get_node("Map")._add_room_and_set(room5scene, instance5, "DoorPosU", "DoorPosL")
	#var instance7 = get_node("Map")._add_room_and_set(room4scene, instance6, "DoorPosR", "DoorPosR")
	#var _instance8 = get_node("Map")._add_room_and_set(room3scene, instance7, "DoorPosD", "DoorPosL")

# generates a set of rooms
func generate():
	var prev_room = null
	
	for i in range(10):
		# if at 0, make the previous room the starting room
		if i == 0:
			prev_room = get_node("Map/room1")
		# pick a random room packed scene from the list of preloaded rooms
		var room_choice = room_options.pick_random()
		
		# add the new room to the tree
		var new_room = get_node("Map")._add_room(room_choice)
		
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
		get_node("Map")._set_room_position(new_room, prev_room, prev_door_choice, new_door_choice)
		# set the previous room to the newly created room to reiterate
		prev_room = new_room

# switch cameras
func switch_cam():
	# current attribute defines if that camera is the one currently in use
	if get_node("Player/CamMount/PlayerCam").current:
		get_node("Player/CamMount/PlayerCam").current = false
	else:
		get_node("Player/TopDownCam").current = false
