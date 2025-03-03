extends Node3D

const SPEED: int = 100
var direction: Vector3 = Vector3.FORWARD

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	global_transform.origin += direction * SPEED * delta
	
