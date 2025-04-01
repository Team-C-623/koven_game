extends CharacterBody3D

const SENS = 0.4
const SPEED = 5.0

@onready var cam_mount = $CamMount
@onready var camera = $CamMount/PlayerCam

func _unhandled_input(event: InputEvent) -> void:
	# allows mouse lock and unlock
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# "ui_cancel" is escape by default
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			# weird bug occurs if you try to rotate camera using mouse x and y movement
			# rotates camera mount node's y angle by mouse x movement
			cam_mount.rotate_y(-event.relative.x * SENS * 0.005)
			# rotates camera node's y angle by mouse y movement
			camera.rotate_x(-event.relative.y * SENS * 0.005)

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (cam_mount.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
