extends Area3D
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var journal_ui: Control = get_node("/root/UIManager/Journal_UI")
func _physics_process(delta: float) -> void:
	sprite_3d.rotate_y(delta)


func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		var new_journal_entry = JournalEntry.new()
		if Journal.instance.add_journal(new_journal_entry):
			journal_ui.update_slots()
			queue_free()
			print("Journal added")
		else:
			print("Journal not added")
