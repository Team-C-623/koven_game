extends Node

@export var player: Player

signal use_item(slot_data)
signal merga_saved

# Player states
var game_over = false
var in_game: bool = false
var is_in_boss_room: bool = false
var is_in_boss_dialogue: bool = false
var is_in_trial_room: bool = false
var has_won_trial_room: bool = false
var is_talking_to_old_witch: bool = false
var is_talking_to_merga: bool = false
var is_entering_dungeon: bool = false
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
