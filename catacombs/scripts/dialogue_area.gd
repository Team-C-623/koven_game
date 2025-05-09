extends Area3D

@onready var main = get_node("/root/Main")
@onready var map = get_node("/root/Main/Map")
@onready var boss: Sprite3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var room: Room
var jury: Sprite3D
var prosecutor: Sprite3D

func _ready() -> void:
	room = $"../.."
	await get_tree().create_timer(0.5).timeout
	if room.room_type == "T":
		jury = $"../Jury"
		prosecutor = $"../Prosecutor"
	elif room.room_type == "B":
		boss = $"../Boss"
	check_sprites_shown()
	# checks if the sprites should be refreshed every time a transition occurs
	TransitionScreen.on_transition_finished.connect(check_sprites_shown)

func _on_body_entered(body: Node3D) -> void:
	if room.room_type == "T":
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
	# boss room creation
	elif room.room_type == "B":
		if body is Player:
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			var boss_dialogue_scene = preload("res://Boss2/scenes/boss_dialogue.tscn").instantiate()
			add_child(boss_dialogue_scene)
			collision_shape_3d.queue_free()

func check_sprites_shown() -> void:
	await get_tree().create_timer(0.1).timeout
	if room.room_type == "T":
		if PlayerManager.has_won_trial_room:
			jury.visible = false
			prosecutor.visible = false
		else:
			jury.visible = true
			prosecutor.visible = true
