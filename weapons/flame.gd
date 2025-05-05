extends Node3D
class_name Flame
const SPEED = 30.0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var hitbox = $FlameHitBox
@onready var sparks_particles: GPUParticles3D = $SparksParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var light: OmniLight3D = $OmniLight3D

@export var attack_damage:= 5.0

func _ready():
	var death_timer = Timer.new()
	death_timer.wait_time = 2.0
	death_timer.timeout.connect(_die)
	death_timer.autostart = true
	add_child(death_timer)

func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -SPEED) * delta
	if ray != null:
		ray.force_raycast_update()
		if ray.is_colliding() and (ray.get_collider() is StaticBody3D or ray.get_collider() is CSGPolygon3D):
			_die()

func _die() -> void:
	if hitbox != null:
		hitbox.queue_free()
	if ray != null:
		ray.queue_free()
	mesh.visible = false
	light.visible = false
	explosion_particles.emitting = true
	sparks_particles.emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _on_flame_hit_box_area_entered(area):
	if area is HitboxComponent:
		var enemy_hitbox : HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		if hitbox != null:
			enemy_hitbox.damage(attack)
		if ray != null:
			_die()
