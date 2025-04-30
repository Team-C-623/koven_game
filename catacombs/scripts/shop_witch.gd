extends Node3D

@onready var interact_area = $InteractPopup

func _ready() -> void:
	interact_area.hide_popup()

func interact():
	ShopMenu.open()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interact_area.can_interact:
		interact()
