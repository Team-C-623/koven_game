extends Node3D

@onready var map = $Map
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# adds a set of rooms to the map
	randomize()
	map.generate(10)
	player.global_position = Vector3(60, 0, 60)

# switch cameras
func switch_cam():
	# current attribute defines if that camera is the one currently in use
	if get_node("Player/CamMount/PlayerCam").current:
		get_node("Player/CamMount/PlayerCam").current = false
	else:
		get_node("Player/TopDownCam").current = false

func generate_new():
	map.generate(10)
