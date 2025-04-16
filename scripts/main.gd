extends Node3D

var room1scene = preload("res://scenes/Rooms/room1.tscn")
var cata_scene = preload("res://scenes/Catacombs/catacombs.tscn")
const PickUp = preload("res://scenes/interactable/pick_up.tscn")

signal entered

@onready var player: CharacterBody3D = $Player
@onready var map = $Map
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var hot_bar_inventory: PanelContainer = $UI/HotBarInventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var new_catacombs = cata_scene.instantiate()
	add_child(new_catacombs)
	_spawn_journals_in_room(new_catacombs) #spawns journal
	
	entered.connect(generate_new)
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	hot_bar_inventory.set_inventory_data(player.inventory_data)
	inventory_interface.force_close.connect(toggle_inventory_interface)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)

#spawns journals
func _spawn_journals_in_room(room):
	var spawners = room.find_children("*", "JournalSpawner", true)
	print(spawners)
	for spawner in spawners:
		spawner.try_spawn_journal()

# switch cameras
func switch_cam():
	# current attribute defines if that camera is the one currently in use
	if get_node("Player/head/PlayerCam").current:
		get_node("Player/head/PlayerCam").current = false
	else:
		get_node("Player/TopDownCam").current = false

func generate_new():
	map.generate(10)
	player.global_position = Vector3(60, 0, 60)
	
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

func _on_entered() -> void:
	map.generate(10)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("generate"):
		generate_new()
