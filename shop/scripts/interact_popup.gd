extends Area3D

var can_interact = false:
	set(value):
		can_interact = value
		$Indicator.visible = value

func _ready() -> void:
	can_interact = false
	$Indicator.visible = false
	
func hide_popup():
	can_interact = false

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		can_interact = true
		

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		can_interact = false
		
