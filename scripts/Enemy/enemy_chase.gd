extends State
class_name EnemyChase

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")
	pass
	
func process(delta: float):
	pass

func _physics_process(delta: float):
	if player:
		var direction = (enemy.player_3d.global_position - enemy.global_position).normalized()
		enemy.velocity = direction * enemy.CHASE_SPEED
	
