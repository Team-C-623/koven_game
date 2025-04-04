extends Resource

class_name Journal
 
@export var journal: Array[JournalEntry]
@export var max_journals: int = 99


signal journal_updated

var texture = preload("res://icon.svg")
static var instance: Journal
static var counter: int = 1




func _init():
	instance = self  
	
func get_number_of_journals():
	var count = 0
	for journal in Journal.instance.journal:
		if journal != null:
			count += 1
	return count

func add_journal(new_journal: JournalEntry) -> bool:
	# Validate input
	if not new_journal:
		push_error("Tried to add null journal to inventory")
		return false
	
	if not new_journal is JournalEntry:
		push_error("Tried to add non-Journal object: ", new_journal)
		return false
	
	# Check capacity
	if get_number_of_journals() >= max_journals:
		emit_signal("inventory_full")
		return false
	
	#set journal entry attributes
	new_journal.entry_id = Journal.counter
	Journal.counter += 1 
	new_journal.content = ""
	new_journal.texture = texture
	journal.append(new_journal)
	emit_signal("journal_updated")
	print("Journal added to journal.tres")
	return true
	
	
