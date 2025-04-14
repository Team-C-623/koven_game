extends Node3D
class_name HealthComponent

@export var MAX_HEALTH := 50.0
var health : float
@onready var health_bar: ProgressBar = $"../HealthBar"

func _ready():
	health = MAX_HEALTH
	health_bar = get_tree().get_root().get_node("HealthBar")
	if health_bar:
		health_bar.max_value = MAX_HEALTH
		health_bar.value = health

func damage(attack: Attack):
	print("Taking damage: ", attack.attack_damage)
	health -= attack.attack_damage
	
	#Updating player health
	if health_bar:
		health_bar.value = health
	
	if health <= 0:
		print("dying")
		get_parent().queue_free()

		
	
	
