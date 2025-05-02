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

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")
	print("Boss Grabbing")
	
	# Wait for 2 seconds before transitioning back to chase state
	timer = 2.0

#func enter_state():
	#enemy.dancing = false
	#print("In BossGrab - enemy.dancing: ", enemy.dancing)
	
func process(delta: float):
	timer -= delta
	if timer <= 0.0:
		print("Going back to chasing")
		Transitioned.emit(self, "BossChase")
	#if is_instance_valid(player) and enemy.global_position.distance_to(player.global_position) > enemy.CHASE_DISTANCE:
	##if instance == null or not is_instance_valid(instance):
		##Transitioned.emit(self, "BossChase")
		#pass

func physics_process(delta: float):
	#if not player or not ray.is_enabled():
		#print("ray not enabled")
		#return
		#
	#var local_direction = ray.to_local(player.global_position).normalized()
	#ray.target_position = local_direction * max_view_distance
	#ray.force_raycast_update()
	#
	#if ray.is_colliding():
		#var hit_player = ray.get_collider()
		#if hit_player.is_in_group("Player Groups"):
			#print("Prayer beads collided with player")
			#has_grabbed = true
			#shoot_beads()
			##has_grabbed = true
			##player.stun(2.0)
			##await get_tree().create_timer(0.4).timeout
			##do_leap()
		#else:
			#return has_grabbed
	enemy.velocity = Vector3.ZERO
	
	#if not player or not ray.is_enabled
	
	shoot_beads()


func shoot_beads():
	if prayer_beads and player:
		print("Spawning prayer beads")
		player.stun(2.0)
		instance = prayer_beads.instantiate()
		get_tree().current_scene.add_child(instance)
		
		instance.position = ray.global_transform.origin
		instance.look_at_from_position(instance.position, player.global_position, Vector3.UP)
		
		# connect grabbing signals
		#instance.connect("bead_hit", Callable(self, "_on_bead_hit"))
		#instance.connect("bead_missed", Callable(self, "_on_bead_missed"))
		#

#func _on_bead_hit():
	#print("Player grabbed!")
	#await get_tree().create_timer(1.0).timeout
	##do_leap()
	#Transitioned.emit(self, "BossChase")
#
#func _on_bead_missed():
	#print("Beads missed player")
	#if is_instance_valid(instance):
		#instance.queue_free()
	#Transitioned.emit(self, "BossChase")
	#
#func do_leap():
	#var direction = (player.global_position - enemy.global_position).normalized()
	#enemy.velocity = direction * 15
	#
	##if enemy.global_position.distance_to(player.global_position) < 2.0:
		##if player.has_method()
