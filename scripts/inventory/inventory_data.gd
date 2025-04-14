extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
var judgement_texture = preload("res://assets/tarotcards/judgement.png")
var wheel_texture = preload("res://assets/tarotcards/wheeloffortune.PNG")
var slot_datas: Array[SlotData]

func _init() -> void:
	slot_datas.resize(10)
	for i in slot_datas.size():
		slot_datas[i] = SlotData.new()

func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	var return_slot_data: SlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
	
	inventory_updated.emit(self)
	return return_slot_data

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
	
	inventory_updated.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null

func use_slot_data(index: int) -> void:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		return
	
	if slot_data.item_data is ItemData:
		slot_data.quantity -= 1
		if slot_data.quantity < 1:
			slot_datas[index] = null
	
	print(slot_data.item_data.name)
	PlayerManager.use_slot_data(slot_data)
	
	inventory_updated.emit(self)

func pick_up_slot_data(slot_data: SlotData) -> bool:
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			slot_datas[index].fully_merge_with(slot_data)
			inventory_updated.emit(self)
			return true
			
	for index in slot_datas.size():
		if not slot_datas[index]:
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true
			
	return false

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)
	
func add_item(item_data: ItemData, quantity: int = 1) -> bool:
	PlayerManager.player.inventory_data
	if item_data.name == "judgement":
		
	elif item_data.name == "wheeloffortune":
		pass
		
	#var new_slot = SlotData.new()
	#new_slot.item_data = item_data
	#new_slot.quantity = quantity
	#print(pick_up_slot_data(new_slot))
	#if pick_up_slot_data(new_slot):
		#spawn_item_visuals(new_slot)  # Visual feedback
		
#		inventory_updated.emit(self)
#		return true
#	else:
#		return false
		
	
		
