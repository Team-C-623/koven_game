extends PanelContainer

signal slot_clicked(index: int, button: int)

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel
@export var data_slot: SlotData
func _ready() -> void:
	#data_slot = SlotData.new()
	pass
	 
func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	if item_data != null:
		texture_rect.texture = item_data.texture
		tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
		
		if slot_data.quantity > 1:
			quantity_label.text = "x%s" % slot_data.quantity
			quantity_label.show()
		else:
			quantity_label.hide()
	


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		#slot_clicked.emit(get_index(), event.button_index)
		var panel = get_parent()
		if panel.is_in_group("inventory_panels"):
			var panel_index = panel.get_index()
			slot_clicked.emit(panel_index, event.button_index)
