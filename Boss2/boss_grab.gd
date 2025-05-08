extends State
class_name BossGrab

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null
@onready var ray: RayCast3D = $"../../RayCast3D"
@onready var lasso_animation: AnimationPlayer = $"../../LassoAnimation"

var angle_cone_of_vision := deg_to_rad(30.0)
var max_view_distance := 5.0
var angle_between_rays := deg_to_rad(5.0)

# Prayer beads
var prayer_beads = load("res://weapons/PrayerBeads.tscn")
var instance
var beads_active = false
var has_grabbed := false
#var timer := 0.0
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
			Transitioned.emit(self, "BossChase")
			reset_cooldown()
		
func physics_process(_delta: float):
	enemy.velocity = Vector3.ZERO
	lasso_animation.play("boss_grab")
	if not beads_active:
		beads_active = true
		shoot_beads()
	await lasso_animation.animation_finished



func shoot_beads():
	if prayer_beads and player:
		print("Spawning prayer beads")
		instance = prayer_beads.instantiate()
		get_tree().current_scene.add_child(instance)
		
		instance.position = ray.global_transform.origin
		instance.look_at_from_position(instance.position, player.global_position, Vector3.UP)
		
		var timer = Timer.new()
		timer.wait_time = 5.0  # Adjust the duration as needed
		timer.one_shot = true
		timer.connect("timeout", Callable(instance, "_on_bead_timeout"))  # This will delete the prayer bead after timeout
		instance.add_child(timer)
		timer.start()
		
func _on_bead_timeout():
	beads_active = false
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
