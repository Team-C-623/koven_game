extends Control
class_name JournalUI
@onready var journal: Journal = preload("res://journal/resources/journal.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var entry_display = $EntryDisplay
@onready var inventory_interface: Control = get_tree().current_scene.get_node("/root/UIManager/InventoryInterface")

var is_open = false

#static var instance: JournalUI

func _init():
	#instance = self  
	pass

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
	for i in range(min(journal.journal.size(),slots.size())):
		slots[i].update(journal.journal[i])
	
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
