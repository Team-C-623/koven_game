extends Node

@onready var label := $label as Label 
@onready var texture: TextureRect = $TextureRect
@onready var sprite: Sprite2D = $TextureRect/Sprite2D

func _ready() -> void:
	Currency.currency_changed.connect(_on_currency_changed)
	update_display()
	#var transparent_style = StyleBoxEmpty.new()
	#add_theme_stylebox_override("CurrencyUI", transparent_style)

func _on_currency_changed(new_amount:int) -> void:
	label.text = str(new_amount)
	var tween := create_tween()
	if new_amount > int(label.text):
		label.modulate = Color.GREEN
	else:
		label.modulate = Color.GREEN
		
	tween.tween_property(label, "modulate", Color.WHITE,0.5)
		

func update_display() -> void:
	label.text = str(Currency.currency)
	
func hide_display():
	label.visible = false
	texture.visible = false
	sprite.visible = false

func show_display():
	label.visible = true
	texture.visible = true
	sprite.visible = true
