extends CharacterBody3D

@onready var sprite_3d: Sprite3D = $Sprite3D
const SPEED = 6.0


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("right"):
		# when player hits "right", shows original orientation
		sprite_3d.scale.x = 1
	elif Input.is_action_just_pressed("left"):
		#when player hits "left", mirros character
		sprite_3d.scale.x = -1
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
