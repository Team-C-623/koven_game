extends Area3D

@onready var main = get_node("/root/Main")

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		main.entered.emit()
