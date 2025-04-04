extends Area3D

@onready var main = $"."

func _on_body_entered(body: Node3D) -> void:
	pass
	#if body is CharacterBody3D:
		#main.entered.emit()
		#print("entered")
