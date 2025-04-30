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
	
	ray.force_raycast_update()
	if ray.is_colliding():
		_die()
		return
	
func _die() -> void:
	mesh.visible = false
	await get_tree().create_timer(1.0).timeout
	queue_free()
	
func _on_knife_hit_box_area_entered(area):
	if area is HitboxComponent:
		print("Hitting player")
		var hitbox : HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		hitbox.damage(attack)
		_die()
