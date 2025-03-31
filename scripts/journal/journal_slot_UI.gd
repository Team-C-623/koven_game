extends Panel

signal entry_selected(entry: JournalEntry)
@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay

var current_entry: JournalEntry = null

	


func update(item: JournalEntry):
	current_entry = item
	if !item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if current_entry:
			entry_selected.emit(current_entry)


 



	
