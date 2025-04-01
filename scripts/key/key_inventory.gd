extends Resource
class_name InventoryKeys

signal keys_updated 
signal inventory_full

@export var max_keys: int = 3  
@export var keys: Array[Key] = []

static var instance: InventoryKeys

func _init():
	instance = self  
	
func get_number_of_keys():
	var count = 0
	for key in InventoryKeys.instance.keys:
		if key != null:
			count += 1
	return count

func add_key(new_key: Key) -> bool:
	# Validate input
	if not new_key:
		push_error("Tried to add null key to inventory")
		return false
	
	if not new_key is Key:
		push_error("Tried to add non-Key object: ", new_key)
		return false
	
	# Check capacity
	if get_number_of_keys() >= max_keys:
		emit_signal("inventory_full")
		return false
	
	# Add key and notify
	keys.append(new_key)
	emit_signal("keys_updated")
	return true
