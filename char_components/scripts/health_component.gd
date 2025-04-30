extends Node3D
class_name HealthComponent

@export var MAX_HEALTH := 50.0
@export var auto_free_on_death := true

var health : float
@export var damage_modifier: float = 1.0
signal health_changed(current_health: float, max_health: float)
@export var is_player := false
var is_dead := false

signal died

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= (attack.attack_damage * damage_modifier)
	if is_player == false:
		SoundManager.play_enemy_damage_sound()
		
	if is_dead:
		return
	
	#play damage sound
	#dont play damage sound if the player is getting hit
	emit_signal("health_changed", health, MAX_HEALTH)
	
	if health <= 0:
		is_dead = true
		print("dying")
		emit_signal("died")
		SoundManager.play_death_sound()
		if get_parent().is_in_group("Enemies Group"):
			get_parent().call_deferred("queue_free")

func reset_health():
	health = MAX_HEALTH
	is_dead = false
	emit_signal("health_changed", health, MAX_HEALTH) 
