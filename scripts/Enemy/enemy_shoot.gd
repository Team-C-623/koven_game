extends State
class_name EnemyShoot

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null
@onready var ray := $"../../NunKnifeRange"

var angle_cone_of_vision := deg_to_rad(30.0)
var max_view_distance := 5.0
var angle_between_rays := deg_to_rad(5.0)

var shoot_cooldown := 2.0
var time_since_last_knife := 0.0 

#Knife
var knife = load("res://weapons/knife.tscn")
var instance
var knife_active = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")

func process(delta: float):
	if enemy.global_position.distance_to(player.global_position) > enemy.CHASE_DISTANCE:
		Transitioned.emit(self, "EnemyWander")

# Needs Work On
func physics_process(delta: float):
	# This is for multi ray cast
	#var cast_count := int(angle_cone_of_vision / angle_between_rays) + 1
	#if player:
		#for index in range(cast_count):
			#var cast_vector := (
				#max_view_distance * Vector3.FORWARD.rotated(Vector3.UP, angle_between_rays * (index - cast_count / 2.0))
			#)
			#
			#ray.cast_to = cast_vector
			#ray.force_raycast_update()
			#if ray.is_colliding() and ray.get_collider() is CharacterBody3D:
				#player = ray.get_collider()
				#break
		#
		#var does_see_player := player != null
		
	# For the single ray cast
	#var direction_to_player = (player.global_position - ray.global_position).normalized()
	#ray.cast_to = direction_to_player * 800  # 800 is an example length, adjust as needed
	
	time_since_last_knife += delta
	
	if not player or not ray.is_enabled():
		print("ray not enabled")
		return
	
	var local_direction = ray.to_local(player.global_position).normalized()
	ray.target_position = local_direction * max_view_distance
	ray.force_raycast_update()

	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("Player Groups"):
			if time_since_last_knife >= shoot_cooldown:
				shoot_knife()
				time_since_last_knife = 0.0
				
func shoot_knife():
	if knife and player:
		instance = knife.instantiate()
		get_tree().current_scene.add_child(instance)
		
		instance.position = ray.global_transform.origin
		instance.transform.basis = ray.global_transform.basis
		
		var direction = (player.global_position - enemy.global_position).normalized()
		instance.velocity = direction * 10
		
					
