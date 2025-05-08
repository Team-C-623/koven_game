extends State
class_name EnemyChase

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null
@onready var chase_animation: AnimationPlayer = $"../../chase_animation"
@onready var ray: RayCast3D = $"../../RayCast3D"

# For Raycasting
var angle_cone_of_vision := deg_to_rad(30.0)
var max_view_distance := 5.0
var angle_between_rays := deg_to_rad(5.0)

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")
	Wwise.set_switch("GAMEPLAY_SWITCH", "COMBAT",self)


func process(_delta: float):
	if is_instance_valid(player) and enemy.global_position.distance_to(player.global_position) > enemy.CHASE_DISTANCE:
		Transitioned.emit(self, "EnemyWander")
		
func physics_process(_delta: float):
	if not player or not ray.is_enabled():
		print("ray not found")
		return

	var local_direction = ray.to_local(player.global_position).normalized()
	ray.target_position = local_direction * max_view_distance
	ray.force_raycast_update()

	if ray.is_colliding() and enemy.get_node("HealthComponent").health > 0:
		var collider = ray.get_collider()
		if collider.is_in_group("Player Groups"):
			var direction = (player.global_position - enemy.global_position).normalized()
			enemy.velocity = direction * enemy.CHASE_SPEED
			chase_animation.play("monk_chase")
