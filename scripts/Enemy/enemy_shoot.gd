extends State
class_name EnemyShoot

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null
@onready var ray := $"../../RayCast3D"

var angle_cone_of_vision := deg_to_rad(30.0)
var max_view_distance := 800.0
var angle_between_rays := deg_to_rad(5.0)

#Knife
var knife = load("res://weapons/knife.tscn")
var instance

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")

func process(delta: float):
	if enemy.global_position.distance_to(player.global_position) > enemy.CHASE_DISTANCE:
		Transitioned.emit(self, "EnemyWander")

# Needs Work On
func physics_process(delta: float):
	var cast_count := int(angle_cone_of_vision / angle_between_rays) + 1
	if player:
		for index in range(cast_count):
			var cast_vector := (
				max_view_distance * Vector3.FORWARD.rotated(Vector3.UP, angle_between_rays * (index - cast_count / 2.0))
			)
			
			ray.cast_to = cast_vector
			ray.force_raycast_update()
			if ray.is_colliding() and ray.get_collider() is CharacterBody3D:
				player = ray.get_collider()
				break
		
		var does_see_player := player != null

func shoot_knife():
	instance = knife.instantiate()
	get_tree().current_scene.add_child(instance)
	
	instance.position = ray.global_position
	instance.transform.basis = ray.global_transform.basis
	
	var direction = (player.global_position - enemy.global_position).normalized()
	instance.set_velocity = direction * 40
				
		
