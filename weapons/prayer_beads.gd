extends Node3D

@onready var mesh = $MeshInstance3D
#@onready var ray = $RayCast3D
@onready var prayer_beads_hit_box = $PrayerBeadsHitBox
#var attack_damage:= 0.0
@export var speed: float = 0.0
var direction: Vector3 = Vector3.ZERO
var timer

signal bead_hit

func _ready():
	var player = get_tree().get_first_node_in_group("Player Groups")
	if player:
		direction = (player.global_position - global_position).normalized()
	
	prayer_beads_hit_box.position = global_position
		
	timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_bead_timeout"))
	add_child(timer)
	timer.start()

func _process(_delta: float) -> void:
	position += direction * speed * _delta
	check_collision()

func check_collision():
	# Check for overlapping areas, such as the player's hitbox
	var overlapping_areas = prayer_beads_hit_box.get_overlapping_areas()
	for area in overlapping_areas:
		_on_prayer_beads_hit_box_area_entered(area)

func _on_bead_timeout():
	mesh.visible = false
	queue_free()
	

func _on_prayer_beads_hit_box_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		bead_hit.emit()
		hitbox.get_parent().stun(2.0)
		_on_bead_timeout()
