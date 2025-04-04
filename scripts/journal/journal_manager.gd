extends Area3D


func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		var new_journal_entry = JournalEntry.new()
		if Journal.instance.add_journal(new_journal_entry):
			JournalUI.instance.update_slots()
			queue_free()
			print("Journal added")
		else:
			print("Journal not added")
