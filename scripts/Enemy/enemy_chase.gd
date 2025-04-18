extends State
class_name EnemyChase

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")
	
func process(_delta: float):
	if enemy.global_position.distance_to(player.global_position) > enemy.CHASE_DISTANCE:
		Transitioned.emit(self, "EnemyWander")
		
func physics_process(_delta: float):
	if player:
		var direction = (player.global_position - enemy.global_position).normalized()
		enemy.velocity = direction * enemy.CHASE_SPEED
	
