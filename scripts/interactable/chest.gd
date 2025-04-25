extends StaticBody3D

signal toggle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData

func _ready() -> void:
	inventory_data = InventoryData.new()
	
		
	
	
func player_interact() -> void:
	toggle_inventory.emit(self)
