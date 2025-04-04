extends Node3D

@onready var map = $Map
var room1scene = preload("res://scenes/Rooms/room1.tscn")
var cata_scene = preload("res://scenes/Catacombs/catacombs.tscn")
const PickUp = preload("res://scenes/interactable/pick_up.tscn")

@onready var player: CharacterBody3D = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var hot_bar_inventory: PanelContainer = $UI/HotBarInventory

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
	var new_instance = cata_scene.instantiate()
	add_child(new_instance)
	await get_tree().process_frame
	_spawn_journals_in_room(new_instance) #spawns journal
	
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	hot_bar_inventory.set_inventory_data(player.inventory_data)
	inventory_interface.force_close.connect(toggle_inventory_interface)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)
	# generate()
	


#spawns journals
func _spawn_journals_in_room(room):
	var spawners = room.find_children("*", "JournalSpawner", true)
	print(spawners)
	for spawner in spawners:
		spawner.try_spawn_journal()

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

func generate_new():
	map._clear_rooms()
	map.new_generate(10)
	
func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		hot_bar_inventory.hide()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hot_bar_inventory.show()
	
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()


func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.get_drop_position() # Vector3.UP # change to player.get_drop_position() when camera fixed
	add_child(pick_up)
