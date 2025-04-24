extends Node3D

var cata_scene = preload("res://scenes/Catacombs/catacombs.tscn")
const PickUp = preload("res://scenes/interactable/pick_up.tscn")

signal entered

@onready var player: CharacterBody3D = $Player
@onready var map = $Map
@onready var inventory_interface: Control = get_node("/root/UIManager/InventoryInterface")
@onready var hot_bar_inventory: PanelContainer = get_node("/root/UIManager/HotBarInventory")
@onready var journal_ui: Control = get_node("/root/UIManager/Journal_UI")

var shop_instance: CanvasLayer = null

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
	
	#inventory_interface.drop_slot_data.connect(_on_inventory_interface_drop_slot_data)
	print("DEBUG: Attempting to connect signal")
	var connect_result = inventory_interface.drop_slot_data.connect(_on_inventory_interface_drop_slot_data)
	print("DEBUG: Connection result:", connect_result == OK)

	
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
	var size = map.generate()
	player.global_position = Vector3(6 * size, 0, 6 * size)
	
func toggle_inventory_interface(external_inventory_owner = null) -> void:
	if ShopMenu.visible or journal_ui.visible:
		return
		
	inventory_interface.visible = not inventory_interface.visible
		
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		hot_bar_inventory.hide()
		SoundManager.play_menu_open()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hot_bar_inventory.show()
		SoundManager.play_menu_open()
	
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
	generate_new()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("generate"):
		generate_new()
