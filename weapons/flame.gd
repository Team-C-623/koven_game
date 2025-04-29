extends Node3D
class_name Flame
const SPEED = 40.0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D

@export var attack_damage:= 10.0

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -SPEED) * delta
	if ray.is_colliding():
		mesh.visible = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
	
func _on_timer_timeout() -> void:
	queue_free()

func _on_flame_hit_box_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		hitbox.damage(attack)
