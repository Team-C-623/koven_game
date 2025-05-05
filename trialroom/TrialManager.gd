extends Node

signal change_sprite(speaker_name: String)

func handle_mutation(mutation: Dictionary) -> void:
	if mutation.has("change_sprite"):
		emit_signal("change_sprite", mutation["change_sprite"])
