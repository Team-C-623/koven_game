extends Node3D
class_name HealthComponent

@export var MAX_HEALTH := 50.0
var health : float

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	print("HealthComponent: Taking damage: ", attack.attack_damage)
	health -= attack.attack_damage
	if health <= 0:
		print("dying")
		get_parent().queue_free()
		
	
	
