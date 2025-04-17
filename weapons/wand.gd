extends Node3D

# Flame
var flame = load("res://weapons/Flame.tscn")
var instance

@onready var wand_anim = $AnimationPlayer
@onready var wand_tip = $root/Main/Player/head
