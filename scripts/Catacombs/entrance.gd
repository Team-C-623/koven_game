extends Area3D

@onready var main = get_node("/root/Main")
@onready var cata_scene = get_node("/root/Main/Catacombs")
func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		SoundManager.play_start_music()
		main.entered.emit()
