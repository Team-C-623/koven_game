extends PanelContainer

const Slot = preload("res://inventory/scenes/slot.tscn")

@onready var background_frame: TextureRect = $Background/BackgroundFrame
@onready var inventory: PanelContainer = $"."
@onready var background: ColorRect = $Background

func _ready():
	# Configure frame texture and scaling
	background_frame.texture = load("res://UI/inventory_new.png")
	background_frame.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	background_frame.stretch_mode = TextureRect.STRETCH_SCALE
	background_frame.z_index = -1 # Draw behind slots
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
	for child in background_frame.get_children():
		for item in child.get_children():
			item.queue_free()
	
	var panels = background_frame.get_children()
 # Create new slots in each panel position
	for panel_index in panels.size():
		var panel = panels[panel_index]
		var slot_data = inventory_data.slot_datas[panel_index]
		var new_slot = Slot.instantiate()
		panel.add_child(new_slot)
		
		#new_slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		new_slot.slot_clicked.connect(inventory_data.on_slot_clicked)  # Now passes correct index)
		# Center slot in panel
		new_slot.anchor_left = 0.5
		new_slot.anchor_top = 0.5
		new_slot.anchor_right = 0.5
		new_slot.anchor_bottom = 0.5
		new_slot.position = -new_slot.size / 2  # Center alignment
		
		# Connect signals
		#new_slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		if slot_data:
			new_slot.set_slot_data(slot_data)
	
