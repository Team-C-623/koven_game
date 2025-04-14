extends Resource
class_name SlotData

const MAX_STACK_SIZE: int = 3
@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1

func _init():
	item_data = ItemData.new()

	
	
func can_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data \
			and quantity < MAX_STACK_SIZE

func can_fully_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data \
			and quantity + other_slot_data.quantity <= MAX_STACK_SIZE

func create_single_slot_data() -> SlotData:
	var new_slot_data = duplicate()
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data

func fully_merge_with(other_slot_data: SlotData) -> void:
	quantity += other_slot_data.quantity
	
