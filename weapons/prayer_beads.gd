extends Node3D

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var prayer_beads_hit_box = $PrayerBeadsHitBox

func _process(delta: float) -> void:
	ray.force_raycast_update()
	if ray.is_colliding():
		_die()
		return
	
func _die() -> void:
	#mesh.visible = false
	emit_signal("hit")
	await get_tree().create_timer(1.0).timeout
	queue_free()


func _on_prayer_beads_hit_box_area_entered(area):
	pass # Replace with function body.
