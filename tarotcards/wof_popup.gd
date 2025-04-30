# UI_WheelOfFortunePopup.gd
extends Control

@onready var label: Label = $Label
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func show_message(effect: String):
	label.text = "Wheel of Fortune grants:\n" + effect
	anim_player.play("show_popup")
