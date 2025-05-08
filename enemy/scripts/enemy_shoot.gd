extends State
class_name EnemyShoot

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null
@onready var ray := $"../../RayCast3D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var angle_cone_of_vision := deg_to_rad(30.0)
var max_view_distance := 5.0
var angle_between_rays := deg_to_rad(5.0)

var shoot_cooldown := 2.0
var time_since_last_knife := 0.0 
@onready var health_component: HealthComponent = $"../../HealthComponent"
@onready var ak_event_3d: AkEvent3D = $"../../AkEvent3D"

var move_direction := 0.5
var move_timer := 0.0
var is_moving := true

#Knife
var knife = load("res://weapons/knife.tscn")
var instance
var knife_active = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")

func process(_delta: float):
	if is_instance_valid(player) and enemy.global_position.distance_to(player.global_position) > enemy.CHASE_DISTANCE:
		Transitioned.emit(self, "EnemyWander")

func physics_process(delta: float):
	time_since_last_knife += delta
	move_timer += delta
	
	if not player or not ray.is_enabled():
		print("ray not enabled")
		return
	
	var local_direction = ray.to_local(player.global_position).normalized()
	ray.target_position = local_direction * max_view_distance
	ray.force_raycast_update()

	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("Player Groups"):
			if is_moving:
				var direction = (player.global_position - enemy.global_position).normalized()
				enemy.velocity = direction * enemy.SPEED
				if move_timer >= move_direction:
					is_moving = false
			else:
				enemy.velocity = Vector3.ZERO
				enemy.move_and_slide()
				if time_since_last_knife >= shoot_cooldown:
					shoot_knife()
					time_since_last_knife = 0.0
					is_moving = true
					move_timer = 0.0

func shoot_knife():
	if health_component.health > 0:
		if knife and player:
			instance = knife.instantiate()
			get_tree().current_scene.add_child(instance)
			
			instance.position = ray.global_transform.origin
			instance.transform.basis = ray.global_transform.basis
				
			var direction = (player.global_position - enemy.global_position).normalized()
			instance.velocity = direction * 10
			animation_player.play("knife")
			
