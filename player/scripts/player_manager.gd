extends Node

@export var player: Player

# Player states
var is_in_trial_room = false

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)

func get_global_position() -> Vector3:
	return player.global_position
