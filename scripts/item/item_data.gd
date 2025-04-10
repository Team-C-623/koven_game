extends Resource
class_name ItemData

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture
@export var cost: int

func use(_target) -> void:
	pass
