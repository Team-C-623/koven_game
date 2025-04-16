extends Node3D
class_name HealthComponent

@export var MAX_HEALTH := 50.0
var health : float

signal health_changed(current_health: float, max_health: float)

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	
	emit_signal("health_changed", health, MAX_HEALTH)
	
	if health <= 0:
		print("dying")
		get_parent().queue_free()

		
	
	
