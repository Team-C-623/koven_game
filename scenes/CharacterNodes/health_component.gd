extends Node3D
class_name HealthComponent

@export var MAX_HEALTH := 50.0
var health : float
@export var damage_modifier: float = 1.0
signal health_changed(current_health: float, max_health: float)
#signal damage_modifier_changed(new_value)

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= (attack.attack_damage * damage_modifier)
	
	emit_signal("health_changed", health, MAX_HEALTH)
	
	if health <= 0:
		print("dying")
		SoundManager.play_death_sound()
		get_parent().queue_free()

		
	
	
