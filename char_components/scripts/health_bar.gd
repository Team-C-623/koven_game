extends ProgressBar

# Player Health Bar
@onready var health_component: HealthComponent = $"../HealthComponent"
@onready var health_timer = $"../health_timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.connect("health_changed", Callable(self, "_on_health_changed"))
	
func _on_health_changed(current_health: float, max_health: float):
	value = (current_health / max_health) * max_value
