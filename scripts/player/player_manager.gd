extends Node

@export var player: Player

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)
	SoundManager.play_card_burn()

func get_global_position() -> Vector3:
	return player.global_position
