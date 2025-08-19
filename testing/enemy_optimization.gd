extends StaticBody3D

const MONK = preload("res://enemy/scenes/monk.tscn")

func _ready() -> void:
	for i in range(20):
		var new_monk = MONK.instantiate()
		add_child(new_monk)
		new_monk.global_position = Vector3(5 * cos(i), 0, 5 * sin(i))
