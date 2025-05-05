extends Control
class_name JournalUI
@onready var journal: Array[JournalEntry] = []
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var entry_display = $EntryDisplay
@onready var inventory_interface: Control = get_tree().current_scene.get_node("/root/UIManager/InventoryInterface")

@export var max_journals: int = 12

var is_open = false

func _ready():
	update_slots()
	close()
	for slot in slots:
		if slot.has_signal("entry_selected"):
			slot.entry_selected.connect(_on_journal_entry_selected)

func _on_journal_entry_selected(entry: JournalEntry):
	entry_display.display_entry(entry)
	entry_display.visible = true
	
func update_slots():
	for i in range(min(journal.size(),slots.size())):
		slots[i].update(journal[i])

func _process(_delta):
	if Input.is_action_just_pressed("journal") and !inventory_interface.visible and !ShopMenu.visible:
		if is_open:
			SoundManager.play_page_turn()
			close()
		else:
			SoundManager.play_page_turn()
			open()

func open():
	visible = true
	is_open = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	entry_display.visible = false # Hide display when reopening

func close():
	visible = false
	is_open = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func get_number_of_journals():
	var count = 0
	for journal_item in journal:
		if journal_item != null:
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
	if get_number_of_journals() >= max_journals:
		emit_signal("inventory_full")
		return false
	
	#new_journal.texture.scale.x = 0.2
	#new_journal.texture.scale.y = 0.2
	journal.append(new_journal)
	print(journal)
	update_slots()
	return true
