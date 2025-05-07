extends Node3D

const SPEED = 5.0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var knife_hit_box = $KnifeHitBox

var attack_damage:= 3.0
var velocity: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -SPEED) * delta
	if ray != null:
		ray.force_raycast_update()
		if ray.is_colliding() and (ray.get_collider() is StaticBody3D or ray.get_collider() is CSGPolygon3D):
			_die()

func _die() -> void:
	mesh.visible = false
	queue_free()
	
func _on_knife_hit_box_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		hitbox.damage(attack)
		_die()
