extends Area3D

func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		var new_key = Key.new()
		if InventoryKeys.instance.add_key(new_key):
			KeySlot.update()
			queue_free()
			print("key added")
		else:
			print("Key not added")
