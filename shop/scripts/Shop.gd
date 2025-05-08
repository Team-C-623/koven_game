extends CanvasLayer

signal show
signal hide

@onready var item_image: TextureRect = %ItemImage
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var item_cost: Label = %ItemCost
@onready var hot_bar_inventory: PanelContainer = get_tree().current_scene.get_node("/root/UIManager/HotBarInventory")
@onready var item_container = %ShopItemsContainer
@onready var currency_ui: Control = get_tree().current_scene.get_node("/root/UIManager/CurrencyUI")

const TAROT_PLACEHOLDER = preload("res://assets/ui/tarot_placeholder.png")

var selected_item = null
var selected_shop_button = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	hide.emit()

func _empty_details():
	item_image.texture = TAROT_PLACEHOLDER
	item_name.text = "Select an Item"
	item_description.text = "-"
	item_cost.text = "-"

func _on_close_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
	hot_bar_inventory.show()
	currency_ui.show_display()
	selected_item = null
	selected_shop_button = null
	_empty_details()
	hide.emit()
	SoundManager.play_buy_sound()

func update_item_description(item: ItemData, selected_button):
	selected_shop_button = selected_button
	selected_item = item
	item_image.texture = item.texture
	item_name.text = item.name
	item_description.text = item.effect + "\n\n" + item.description
	item_cost.text = str(item.cost)

func open():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = true
	hot_bar_inventory.hide()
	currency_ui.hide_display()
	show.emit()

func _on_buy_pressed() -> void:
	if selected_item != null && Currency.currency >= selected_item.cost:
		Currency.subtract_currency(selected_item.cost)
		PlayerManager.player.inventory_data.add_item(selected_item)
		SoundManager.play_buy_sound()
		# remove the selected card from the shop list
		for i in range(item_container.data.shop_items.size()):
			if selected_item.name == item_container.data.shop_items[i].name:
				item_container.data.shop_items.remove_at(i)
				break
		# remove the button from the shop UI
		selected_shop_button.queue_free()
		selected_item = null
		selected_shop_button = null
		_empty_details()
