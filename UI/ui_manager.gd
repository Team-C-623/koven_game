extends CanvasLayer
@onready var inventory_interface: Control = $InventoryInterface
@onready var hot_bar_inventory: PanelContainer = $HotBarInventory
@onready var currency_ui: Control = $CurrencyUI
@onready var journal_ui: JournalUI = $Journal_UI

@export var inventory_data: InventoryData
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check layer and visibility
	print("CanvasLayer layer: ", get_layer())
	pass
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
