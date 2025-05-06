extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	if anim_name == "cut_to_black":
		await get_tree().create_timer(1.0).timeout
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false

func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")

func death_transition():
	color_rect.visible = true
	#SoundManager.stop_on_death()
	animation_player.play("cut_to_black")
