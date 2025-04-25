extends Node3D
class_name HealthComponent

@export var MAX_HEALTH := 50.0
@export var auto_free_on_death := true

var health : float
var is_dead := false

signal health_changed(current_health: float, max_health: float)
signal died

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	if is_dead:
		return
		
	health -= attack.attack_damage
	
	emit_signal("health_changed", health, MAX_HEALTH)
	
	if health <= 0:
		is_dead = true
		print("dying")
		emit_signal("died")
		SoundManager.play_death_sound()
		if get_parent().is_in_group("Enemies Group"):
			get_parent().call_deferred("queue_free")

		
	
	
