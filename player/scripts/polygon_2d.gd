extends Polygon2D

# You can tweak these values in the Inspector
@export var width: float = 100.0
@export var height: float = 20.0
@export var tip_width: float = 20.0

func _ready() -> void:
	_update_polygon()

func _process(delta: float) -> void:
	# Here you could update the width based on progress, e.g.:
	# width = current_value / max_value * max_width
	# _update_polygon()
	pass

func _update_polygon():
	polygon = [
		Vector2(0, 0),
		Vector2(width - tip_width, 0),
		Vector2(width, height / 2),
		Vector2(width - tip_width, height),
		Vector2(0, height)
	]
