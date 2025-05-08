extends State
class_name BossGrab

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null
@onready var ray: RayCast3D = $"../../RayCast3D"
@onready var leap_effect: TextureRect = $"../../TextureRect"
@onready var leap_animation: AnimationPlayer = $"../../LeapAnimation"

var max_view_distance := 5.0

# Prayer beads
var prayer_beads = load("res://weapons/PrayerBeads.tscn")
var instance
#var is_leaping := false
var cooldown := 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")
	print("Boss Grabbing")
	reset_cooldown()

func reset_cooldown():
	cooldown = randf_range(1.0, 2.0)
	
func process(delta: float):
	if is_instance_valid(player):
		var _distance = enemy.global_position.distance_to(player.global_position)
		cooldown -= delta
		if cooldown <= 0.0:
			#enemy.visible = true
			enemy.is_leaping = false
			Transitioned.emit(self, "BossChase")
			reset_cooldown()
		
func physics_process(_delta: float):
	if not player or not ray.is_enabled():
		print("ray not enabled")
		return
	
	var local_direction = ray.to_local(player.global_position).normalized()
	ray.target_position = local_direction * max_view_distance
	ray.force_raycast_update()

	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("Player Groups"):
			enemy.is_leaping = true
			enemy.velocity = Vector3.ZERO
			shoot_beads()
	
func shoot_beads():
	if prayer_beads and player:
		instance = prayer_beads.instantiate()
		get_tree().current_scene.add_child(instance)
		
		instance.position = ray.global_transform.origin
		instance.transform.basis = ray.global_transform.basis
		do_leap()
		
func do_leap():
	#enemy.visible = false
	leap_animation.play("grab_animation")
	enemy.rotation = Vector3.ZERO
	var direction = (player.global_position - enemy.global_position).normalized()
	enemy.velocity = direction * 15

	
