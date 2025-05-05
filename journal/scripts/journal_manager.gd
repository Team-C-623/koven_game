extends Area3D
@onready var sprite_3d: Sprite3D = $Sprite3D

const JOURNAL_LIST: JournalList = preload("res://journal/resources/journal_list.tres")

var journal_list = JOURNAL_LIST.Journals

func _physics_process(delta: float) -> void:
	sprite_3d.rotate_y(delta)

func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		SoundManager.play_page_turn()
		var new_journal_entry: JournalEntry
		if journal_list.size() > 0:
			new_journal_entry = journal_list.pick_random()
			var journal_valid = Journal.add_journal(new_journal_entry)
			if journal_valid:
				for i in range(journal_list.size()):
					print(new_journal_entry.entry_id)
					if journal_list[i].entry_id == new_journal_entry.entry_id:
						journal_list.remove_at(i)
						print(journal_list)
						break
				queue_free()
				print("Journal added")
			else:
				print("Journal not added")
		else:
			# notification here of some kind?
			queue_free()
			print("No journals remaining")
