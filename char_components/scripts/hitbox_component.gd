extends Area3D
class_name HitboxComponent

@export var health_component : HealthComponent

func _ready():
	if not health_component:
		health_component = get_parent().get_node_or_null("HealthComponent")

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
