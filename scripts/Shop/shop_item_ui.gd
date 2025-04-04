class_name ShopItemUI extends Button

var item_data: ItemDataShoppable : set = set_item_data

@onready var label: Label = $Label
@onready var price_label: Label = $PriceLabel
@onready var item_image: TextureRect = $ItemImage

func _ready() -> void:
	item_image.texture = null
	label.text = ""
	focus_entered.connect(item_focus)

func set_item_data(item):
	item_data = item
	if item_data == null:
		return
	item_image.texture = item_data.texture
	label.text = item_data.name
	price_label.text = str(item_data.cost)

func item_focus():
	if item_data != null:
		ShopMenu.update_item_description(item_data)
