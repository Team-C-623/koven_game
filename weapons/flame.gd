extends CharacterBody3D

@export var speed: float = 20.0
@export var direction: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	velocity = direction * speed # Move Forward
	move_and_slide()
	
