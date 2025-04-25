extends PanelContainer

const Slot = preload("res://scenes/inventory/slot.tscn")

@onready var background_frame: TextureRect = $Background/BackgroundFrame
@onready var margin_container: MarginContainer = $Background/BackgroundFrame/MarginContainer
@onready var item_grid: GridContainer = $Background/BackgroundFrame/MarginContainer/ItemGrid
@onready var inventory: PanelContainer = $"."
@onready var background: ColorRect = $Background



func _ready():
	# Configure frame texture and scaling
	background_frame.texture = load("res://UI/INVENTORYFULLSPREADEXPANDED.png")
	background_frame.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	background_frame.stretch_mode = TextureRect.STRETCH_SCALE
	
	#margin_container.add_theme_constant_override("margin_left", 10)
	#margin_container.add_theme_constant_override("margin_right", 10)
	#margin_container.add_theme_constant_override("margin_top", 10)
	#margin_container.add_theme_constant_override("margin_bottom", 10)
	#margin_container.modulate.a = 0.5
	#inventory.modulate.a = 0.5
	background_frame.z_index = 2  # Draw behind slots
	item_grid.z_index = 1 # Draw above frame
	
	background.color = Color(0,0,0,0)  # Fully transparent
	background.mouse_filter = Control.MOUSE_FILTER_STOP
	background.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	background.size_flags_vertical = Control.SIZE_EXPAND_FILL
	background.mouse_filter = Control.MOUSE_FILTER_STOP
	background.gui_input.connect(_on_background_gui_input)

func _on_background_gui_input(event: InputEvent):
	# Forward background clicks to inventory interface
	if event is InputEventMouseButton and event.pressed:
		get_parent()._on_inventory_background_click(event)
	
func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	

	#for slot_data in inventory_data.slot_datas:
	#	var slot = Slot.instantiate()
	#	item_grid.add_child(slot)
	#	
	#	slot.slot_clicked.connect(inventory_data.on_slot_clicked)
	#	
	#	if slot_data:
	#		slot.set_slot_data(slot_data)
	for i in range(inventory_data.slot_datas.size()):
		var slot_data = inventory_data.slot_datas[i]
		var slot = Slot.instantiate()
	
	# Set custom position in grid
		item_grid.add_child(slot)
		item_grid.move_child(slot, i)  # Control order
	
	# Configure grid properties
		item_grid.columns = 6  # Set your desired column count
		item_grid.add_theme_constant_override("h_separation", 10)  # Horizontal spacing
		item_grid.add_theme_constant_override("v_separation", 10)  # Vertical spacing
	
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		if slot_data:
			slot.set_slot_data(slot_data)
		
