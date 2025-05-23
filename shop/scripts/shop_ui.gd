class_name ShopUI extends Control

const SHOP_ITEM = preload("res://shop/scenes/shop_item_button.tscn")

@export var data: ShopData

@onready var main = get_node("/root/Main")

func _ready() -> void:
	ShopMenu.show.connect(update_shop)
	ShopMenu.hide.connect(clear_shop)
	clear_shop()
	create_new_shop()
	# generates a new shop list on a transition (jank)
	TransitionScreen.on_transition_finished.connect(create_new_shop)

func clear_shop():
	for c in get_children():
		c.queue_free()

func update_shop():
	clear_shop()
	for item in data.shop_items:
		var new_item = SHOP_ITEM.instantiate()
		add_child(new_item)
		new_item.item_data = item

func create_new_shop():
	data = ShopData.new()
	data.generate_shop()
