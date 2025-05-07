extends CanvasLayer
class_name JournalUI
@onready var journal: Array[JournalEntry] = []
@onready var journal_page = %JournalPage
@onready var journal_page_container = %ButtonContainer
@onready var inventory_interface: Control = get_tree().current_scene.get_node("/root/UIManager/InventoryInterface")

@export var max_journals: int = 12

const JOURNAL_BUTTON = preload("res://journal/scenes/journal_ui_button.tscn")
const EMPTY_JOURNAL = preload("res://assets/journal/journal_empty_cropped.png")

var is_open = false
var selected_journal = null

func _ready():
	update_slots()
	close()

func update_slots():
	clear_journal()
	for page in journal:
		var new_page = JOURNAL_BUTTON.instantiate()
		journal_page_container.add_child(new_page)
		new_page.journal_data = page

func _process(_delta):
	if Input.is_action_just_pressed("journal") and !inventory_interface.visible and !ShopMenu.visible and !PlayerManager.is_in_trial_room:
		if is_open:
			SoundManager.play_journal_close()
			close()
		else:
			SoundManager.play_journal_open()
			open()

func update_journal_description(new_journal: JournalEntry):
	selected_journal = new_journal
	journal_page.texture = new_journal.texture

func open():
	visible = true
	is_open = true
	update_slots()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 

func clear_journal():
	selected_journal = null
	journal_page.texture = EMPTY_JOURNAL
	for c in journal_page_container.get_children():
		c.queue_free()

func close():
	visible = false
	is_open = false
	clear_journal()
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
	
	journal.append(new_journal)
	update_slots()
	return true
