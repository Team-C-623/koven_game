extends CanvasLayer

signal show
signal hide

@onready var item_image: TextureRect = %ItemImage
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var item_cost: Label = %ItemCost

@onready var item_container = %ShopItemsContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	hide.emit()

func _on_close_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
	hide.emit()

func update_item_description(item: ItemData):
	item_image.texture = item.texture
	item_name.text = item.name
	item_description.text = item.description
	item_cost.text = str(item.cost)

func open():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = true
	show.emit()
