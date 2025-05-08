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

@onready var sprite: Sprite3D = $Sprite3D
@onready var damage_timer: Timer = $DamageTimer

var direction: Vector3
var right_bounds: Vector3
var left_bounds: Vector3
var attack_damage:= 2.0
var current_hitbox: HitboxComponent = null
var dancing := true

func _ready():
	$HitboxComponent.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))
	$HitboxComponent.connect("area_exited", Callable(self, "_on_hitbox_area_exited"))
	$DamageTimer.connect("timeout", Callable(self, "_on_DamageTimer_timeout"))
	call_deferred("_find_player")

func _find_player():
	player_3d = get_tree().get_first_node_in_group("Player Groups")
	if player_3d:
		print("Player found: ", player_3d.name)
	else:
		print("⚠️ Player not found in group 'Player Groups'")

func _physics_process(delta: float) -> void:
	sprite.rotate_y(delta)

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
	
	if health_component.health <= 0:
		#SoundManager.play_death_sound()
		pass
	
func _on_hitbox_area_entered(area: Area3D) -> void:
	if area is HitboxComponent:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		current_hitbox = area
		current_hitbox.damage(attack)
		damage_timer.start()

func _on_hitbox_area_exited(area: Area3D) -> void:
	if area == current_hitbox:
		current_hitbox = null
		damage_timer.stop()

func _on_DamageTimer_timeout():
	if current_hitbox:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		current_hitbox.damage(attack)

func play_lasso_windup():
	SoundManager.play_lasso_windup()
	
