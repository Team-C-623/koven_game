extends State
class_name BossGrab

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null
@onready var ray: RayCast3D = $"../../RayCast3D"

var angle_cone_of_vision := deg_to_rad(30.0)
var max_view_distance := 5.0
var angle_between_rays := deg_to_rad(5.0)

# Prayer beads
var prayer_beads = load("res://weapons/PrayerBeads.tscn")
var instance
var beads_active = false
var has_grabbed := false
var timer := 0.0
var wind_up_

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")

func process(delta: float):
	if has_grabbed and is_instance_valid(player) and enemy.global_position.distance_to(player.global_position) > enemy.CHASE_DISTANCE:
		Transitioned.emit(self, "BossChase")

func physics_process(delta: float):
	if has_grabbed:
		return
		
	if not player or not ray.is_enabled():
		print("ray not enabled")
		return
		
	
	if ray.is_colliding():
		var hit_player = ray.get_collider()
		if hit_player.is_in_group("Player Groups"):
			shoot_beads()
			has_grabbed = true
			player.stun(2.0)
			await get_tree().create_timer(0.4).timeout
			
			do_leap()

func shoot_beads():
	if prayer_beads and player:
		instance = prayer_beads.instantiate()
		get_tree().current_scene.add_child(instance)
		
		instance.position = ray.global_transform.origin
		instance.transform.basis = ray.global_transform.origin
		
		var direction = (player.global_position - enemy.global_position).normalized()
		

func do_leap():
	var direction = (player.global_position - enemy.global_position).normalized()
	enemy.velocity = direction * 15
