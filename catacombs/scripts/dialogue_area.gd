extends Area3D

@onready var main = get_node("/root/Main")
@onready var map = get_node("/root/Main/Map")
@onready var boss: Sprite3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var room: Room
var jury: Sprite3D
var prosecutor: Sprite3D

const BOSSROOM_1_TP = preload("res://rooms/scenes/bossroom_1_tp.tscn")

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
			PlayerManager.is_in_boss_room = true
			var boss_room = BOSSROOM_1_TP.instantiate()
			map.add_child(boss_room)
			boss_room.global_position = Vector3(0, 60, 0)
			var boss_room_spawn = boss_room.global_position + Vector3(0, 0, 4)
			PlayerManager.player.global_position = boss_room_spawn

func check_sprites_shown() -> void:
	await get_tree().create_timer(0.1).timeout
	if room.room_type == "T":
		if PlayerManager.has_won_trial_room:
			jury.visible = false
			prosecutor.visible = false
		else:
			jury.visible = true
			prosecutor.visible = true
