extends Area3D

@onready var main = get_node("/root/Main")
@onready var jury: Sprite3D = $"../Jury"
@onready var prosecutor: Sprite3D = $"../Prosecutor"
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player and !PlayerManager.has_won_trial_room:
		TarotManager.judgement_active = false
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		var trial_scene = preload("res://trialroom/trialroom1.tscn").instantiate()
		
		if trial_scene.has_signal("trial_failed"):
			trial_scene.trial_failed.connect(main.on_trial_failed)
			
		add_child(trial_scene)
		SoundManager.play_trial_room_music()
		collision_shape_3d.queue_free()

func _process(_float) -> void:
	if PlayerManager.has_won_trial_room:
		jury.visible = false
		prosecutor.visible = false
	else:
		jury.visible = true
		prosecutor.visible = true
