extends Node3D

@onready var map = $Map
var room1scene = preload("res://scenes/Rooms/room1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# adds a set of rooms to the map
	map._add_first_room(room1scene)

# switch cameras
func switch_cam():
	# current attribute defines if that camera is the one currently in use
	if get_node("Player/CamMount/PlayerCam").current:
		get_node("Player/CamMount/PlayerCam").current = false
	else:
		get_node("Player/TopDownCam").current = false

func generate_new():
	map._clear_rooms()
	map.new_generate(10)
