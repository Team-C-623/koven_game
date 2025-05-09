extends Area3D
@onready var sprite_3d: Sprite3D = $Sprite3D

var JOURNAL_LIST: JournalList = preload("res://journal/resources/journal_list.tres")
var journal_list = JOURNAL_LIST.Journals

func _ready() -> void:
	Journal.reset_journal_list.connect(reset)
	
func _physics_process(delta: float) -> void:
	sprite_3d.rotate_y(delta)
	print("JOURNAL_LIST_SIZE: ", journal_list.size())

func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		SoundManager.play_journal_pickup()
		var new_journal_entry: JournalEntry
		if journal_list.size() > 0:
			new_journal_entry = journal_list.pick_random()
			var journal_valid = Journal.add_journal(new_journal_entry)
			if journal_valid:
				for i in range(journal_list.size()):
					if journal_list[i].entry_id == new_journal_entry.entry_id:
						journal_list.remove_at(i)
						break
			queue_free()
		else:
			# this occurs if no journals are left for the player to collect
			# notification of some kind for the player?
			queue_free()

func reset():
	var journal_one = preload("res://journal/resources/entry1.tres")
	var journal_two = preload("res://journal/resources/entry2.tres")
	var journal_three = preload("res://journal/resources/entry3.tres")
	var journal_four = preload("res://journal/resources/entry4.tres")
	journal_list.clear()
	journal_list.append(journal_one.duplicate(true))
	journal_list.append(journal_two.duplicate(true))
	journal_list.append(journal_three.duplicate(true))
	journal_list.append(journal_four.duplicate(true))
	print("JOURNAL_LIST_SIZE: ", journal_list.size())
	
