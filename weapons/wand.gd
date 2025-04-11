extends Node3D

# Flame
var flame = load("res://weapons/Flame.tscn")
var instance

@onready var wand_anim = $AnimationPlayer
@onready var wand_tip = $root/Main/Player/head

#func shoot():
	#if !wand_anim.is_playing():
		#wand_anim.play("cast")
		#instance = flame.instantiate()
		#instance.position = wand_tip.global_position
		#instance.transform.basis = wand_tip.global_transform.basis
		#get_parent().add_child(instance)
