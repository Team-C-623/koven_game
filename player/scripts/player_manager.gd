extends Node

@export var player: Player
signal use_item(slot_data)
# Player states
var is_in_trial_room = false
var has_won_trial_room = false
var is_talking_to_old_witch = false


signal merga_saved
var has_saved_merga := false:
	set(value):
		has_saved_merga = value
		if value:
			merga_saved.emit()


func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)
	use_item.emit(slot_data)

	

func get_global_position() -> Vector3:
	return player.global_position
