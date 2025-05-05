extends ProgressBar
class_name BossHealthBar

# Boss Health Bar
@onready var health_timer: Timer = $"../health_timer"
@onready var health_component: HealthComponent = $"../HealthComponent"
@onready var player = get_tree().get_first_node_in_group("Player Groups")
@onready var boss = get_parent()

var show_distance = 3.5

func _ready() -> void:
	health_component.connect("health_changed", Callable(self, "_on_health_changed"))
	visible = false

func _process(_delta: float) -> void:
	if player and boss:
		var distance = boss.global_position.distance_to(player.global_position)
		
		if distance <= show_distance:
			visible = true
		else:
			visible = false

func _on_health_changed(current_health: float, max_health: float):
	value = (current_health / max_health) * max_value
