extends Panel

class_name KeySlotUI

@onready var key_sprite: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var counter_label: Label = $CenterContainer/Panel/Counter
@onready var keys: InventoryKeys = preload("res://resources/keys/KeyInventory.tres")
#for some reason this only works with the var keys even though it should work without
#it should access the get_number_of_keys function through the InventoryKeys singleton in the key_inventory.gd script
@onready var texture: = preload("res://icon.svg") #texture for the key ui slot
func _ready():
	await get_tree().process_frame
	update()
	

	
func update():
	var num_of_keys = InventoryKeys.instance.get_number_of_keys()
	if num_of_keys > 0:
		key_sprite.visible = true
		key_sprite.texture = texture
		counter_label.text = str(num_of_keys)
	else:
		key_sprite.visible = false
		counter_label.text = ''


 



	
