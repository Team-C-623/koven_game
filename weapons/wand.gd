extends Node3D

@onready var wand: Node3D = $"."
@onready var player_cam: Camera3D = $root/Main/Player/PlayerCam
@onready var player: CharacterBody3D = $".."
const FLAME = preload("res://weapons/Flame.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# NEED THIS CODE FOR DEBUGGING THE PLAYER_CAM
	player_cam = get_node_or_null("/root/Main/Player/PlayerCam")


# Getting the cursors position in the 3D space
func get_cursor_world_position():
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	var from = player_cam.project_ray_origin(mouse_pos)
	var to = from + player_cam.project_ray_normal(mouse_pos) * 1000
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result: 
		return result.position
	else:
		return to
		
# Shooting function
func shoot():
	if FLAME:
		# initialize the flame icon
		var flame_instance = FLAME.instantiate()
		get_tree().get_root().add_child(flame_instance)
		
		# position of player and flame stay consistent
		flame_instance.global_transform.origin = wand.global_transform.origin
		var target_position = get_cursor_world_position()
		var direction = (target_position - flame_instance.global_transform.origin).normalized()
		
		flame_instance.direction = direction 
		flame_instance.velocity = direction * 20
		
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot()
		
