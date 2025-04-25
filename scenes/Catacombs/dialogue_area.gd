extends Area3D

@onready var main = get_node("/root/Main")

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		TarotManager.end_timer_early()
		get_tree().change_scene_to_file("res://trialroom/trialroom1.tscn")
