extends CharacterBody3D
class_name Boss2

@onready var player_3d = get_node("/root/Main/Player")
@export var SPEED: float = 0.5
@export var CHASE_SPEED: float = 1.5
@export var GRAB_DISTANCE: float = 2.0
@export var ACCELERATION: float = 2.0
@export var CHASE_DISTANCE: float = 3.0  # Distance at which the enemy starts chasing
@export var gravity: float = 9.8
@onready var health_component: HealthComponent = $HealthComponent
@onready var boss_leap: CanvasLayer = $BossLeap
@onready var sprite: Sprite3D = $Sprite3D
@onready var damage_timer: Timer = $DamageTimer
@onready var state_machine: StateMachine = $StateMachine

var direction: Vector3
var right_bounds: Vector3
var left_bounds: Vector3
var attack_damage:= 2.0
var current_hitbox: HitboxComponent = null
var sprite_origin_position: Vector3
@onready var lasso_animation: AnimationPlayer = $LassoAnimation
@onready var leap_animation: AnimationPlayer = $LeapAnimation


#bob variable
const BOB_FREQ = 2.0 #2.0
const BOB_AMP = 0.08 #0.08
var t_bob = 0.0

func _ready():
	sprite_origin_position = sprite.position
	$HitboxComponent.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))
	$HitboxComponent.connect("area_exited", Callable(self, "_on_hitbox_area_exited"))
	$DamageTimer.connect("timeout", Callable(self, "_on_DamageTimer_timeout"))
	call_deferred("_find_player")

func _find_player():
	player_3d = get_tree().get_first_node_in_group("Player Groups")
	if player_3d:
		print("Player found: ", player_3d.name)

func _physics_process(delta: float) -> void:
	sprite.rotate_y(delta * 3)
	# Debugging
	if player_3d == null:
		return  # Exit if no player is assigned
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	move_and_slide()
	
	# Always face the player
	look_at(player_3d.position)
	t_bob += delta * velocity.length() * float(is_on_floor()) 
	var new_head_pos = _headbob(t_bob)
	sprite.position = sprite_origin_position + new_head_pos
	
	#if health_component.health <= 0:
		#SoundManager.play_death_sound()
	#	pass
	
func _on_hitbox_area_entered(area: Area3D) -> void:
	if area is HitboxComponent and health_component.health > 0:
		var attack = Attack.new()
		SoundManager.play_boss_knife()
		attack.attack_damage = attack_damage
		current_hitbox = area
		current_hitbox.damage(attack)
		damage_timer.start()

func _on_hitbox_area_exited(area: Area3D) -> void:
	if area == current_hitbox:
		current_hitbox = null
		damage_timer.stop()

func _on_DamageTimer_timeout():
	if current_hitbox and health_component.health > 0:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		current_hitbox.damage(attack)

func play_lasso_windup():
	SoundManager.play_lasso_windup()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP + 0.18
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func play_death_sound():
	SoundManager.play_enemy_death()

func _on_health_component_boss_2_die() -> void:
	PlayerManager.boss_defeated = true
	set_physics_process(false)
	state_machine.set_physics_process(false)
	state_machine.set_process(false)
	lasso_animation.stop()
	leap_animation.stop()
	#dying.emit()
	lasso_animation.play("boss_death")
	#await lasso_animation.animation_finished #for some reason this line gets stuck and nothing after it will execute
	await get_tree().create_timer(2.0).timeout
	TransitionScreen.transition()
	#var credits = "res://credits/scenes/credits.tscn"
	var credits_scene = preload("res://credits/scenes/credits.tscn").instantiate()
	credits_scene.ended.connect(_on_credits_ended)
	await TransitionScreen.on_transition_finished
	get_tree().current_scene.add_child(credits_scene)
	#get_tree().change_scene_to_file(credits)
	
func _on_credits_ended():
	var start_screen = "res://start_screen/scenes/start_screen.tscn"
	Wwise.set_state("LOCATION", "MAIN_MENU")
	Currency.reset()
	Journal.reset()
	PlayerManager.boss_defeated = false
	PlayerManager.is_in_main_menu = true
	get_tree().change_scene_to_file(start_screen)
	
	
	


	
