extends StaticBody3D

signal toggle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData
const CARDS_LIST = preload("res://tarotcards/resources/cards_list.tres")

@onready var interact_area = $InteractPopup

func _ready() -> void:
	inventory_data = InventoryData.new()
	var new_slot_data = SlotData.new()
	new_slot_data.item_data = CARDS_LIST.Cards.pick_random()
	inventory_data.slot_datas = [null, null, null, null, null, null, null, null, null, null]
	inventory_data.slot_datas[randi_range(0, 9)] = new_slot_data

func player_interact() -> void:
	print("AUGH")
	toggle_inventory.emit(self)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interact_area.can_interact:
		player_interact()
