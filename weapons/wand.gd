extends Node3D

# Flame
var flame = load("res://weapons/Flame.tscn")
var instance

@onready var wand_anim = $AnimationPlayer
#@onready var wand_tip = $root/Main/Player/head

#bob variable
const BOB_FREQ = 2.0 #2.0
const BOB_AMP = 0.08 #0.08
var t_bob = 0.0

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
