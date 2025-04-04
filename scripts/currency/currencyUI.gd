extends Node

@onready var label := $label as Label 

func _ready() -> void:
	Currency.currency_changed.connect(_on_currency_changed)
	update_display()

func _on_currency_changed(new_amount:int) -> void:
	label.text = str(new_amount)
	var tween := create_tween()
	if new_amount > int(label.text):
		label.modulate = Color.GREEN
	else:
		label.modulate = Color.RED
		
	tween.tween_property(label, "modulate", Color.WHITE,0.5)
		

func update_display() -> void:
	label.text = str(Currency.currency)
