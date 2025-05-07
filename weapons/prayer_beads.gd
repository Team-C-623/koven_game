extends Node3D

@onready var mesh = $MeshInstance3D
#@onready var ray = $RayCast3D
@onready var prayer_beads_hit_box = $PrayerBeadsHitBox
#var attack_damage:= 0.0

signal bead_hit
#signal bead_missed

func _process(_delta: float) -> void:
	#ray.force_raycast_update()
	#if ray.is_colliding():
		#_die()
		#return
	pass


func _on_prayer_beads_hit_box_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		#var attack = Attack.new()
		#attack.attack_damage = attack_damage
		#hitbox.damage(attack)
		hitbox.get_parent().stun(2.0)
		bead_hit.emit()
		queue_free()
