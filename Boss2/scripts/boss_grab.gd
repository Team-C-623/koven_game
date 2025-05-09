extends State
class_name BossGrab

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null
@onready var ray: RayCast3D = $"../../RayCast3D"
@onready var boss_leap: CanvasLayer = $"../../BossLeap"
@onready var lasso_animation: AnimationPlayer = $"../../LassoAnimation"
@onready var leap_animation: AnimationPlayer = $"../../LeapAnimation"

var max_view_distance := 5.0

# Prayer beads
var prayer_beads = load("res://weapons/PrayerBeads.tscn")
var instance
var cooldown := 0.0
var shoot_cooldown := 2.0
var time_since_last_beads := 0.0 

var leap_stun_time := 1.0  # seconds of stun after leap
var in_stun := false
var stun_timer := 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")
	print("Boss Grabbing")
	reset_cooldown()
	
func reset_cooldown():
	cooldown = randf_range(1.0, 2.0)
	
func process(delta: float):
	# When the stun ends
	#if in_stun:
		#stun_timer -= delta
		#if stun_timer <= 0.0:
			#set_visibility(false)
			#Transitioned.emit(self, "BossChase")
			#in_stun = false
	
	# if missed player
	if is_instance_valid(player):
		cooldown -= delta
		if cooldown <= 0.0:
			#set_visibility(false)
			Transitioned.emit(self, "BossChase")
			reset_cooldown()
		
func physics_process(_delta: float):
	time_since_last_beads += _delta
	
	if not player or not ray.is_enabled():
		print("ray not enabled")
		return
	
	var local_direction = ray.to_local(player.global_position).normalized()
	ray.target_position = local_direction * max_view_distance
	ray.force_raycast_update()
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("Player Groups"):
			if time_since_last_beads >= shoot_cooldown:
				enemy.velocity = Vector3.ZERO
				enemy.move_and_slide()
				#lasso_animation.play("boss_grab")
				#lasso_animation.connect("animation_finished", Callable(self, "_on_lasso_animation"), CONNECT_ONE_SHOT)
				shoot_beads()
				time_since_last_beads = 0.0
				
func _on_lasso_animation(anim_name: String):
	if anim_name == "boss_grab":
		ray.force_raycast_update()
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider.is_in_group("Player Groups"):
				shoot_beads()
			
func shoot_beads():
	if prayer_beads and player:
		instance = prayer_beads.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.position = ray.global_transform.origin
		instance.transform.basis = ray.global_transform.basis
		do_leap()
		#instance.connect("bead_hit", Callable(self, "_on_bead_hit"))
#
#func _on_bead_hit():
	#do_leap()
		
func do_leap():
	#in_stun = true
	#stun_timer = leap_stun_time
	#set_visibility(true)
	leap_animation.play("leap_animation")
	var direction = (player.global_position - enemy.global_position).normalized()
	enemy.velocity = direction * 25
	
#func set_visibility(is_leaping: bool):
	#if is_leaping:
		##enemy.visible = false
		##boss_leap.visible = true
		#leap_animation.play("leap_animation")
	#else:
		#return
		
	
