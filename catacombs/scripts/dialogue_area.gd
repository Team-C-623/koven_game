extends Area3D

@onready var main = get_node("/root/Main")

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		TarotManager.judgement_active = false
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		var trial_scene = preload("res://trialroom/trialroom1.tscn").instantiate()
		add_child(trial_scene)
		SoundManager.play_trial_room_music()
