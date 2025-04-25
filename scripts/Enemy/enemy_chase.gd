extends State
class_name EnemyChase

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null
@onready var chase_animation: AnimationPlayer = $"../../chase_animation"

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")
	#if Global.player:
		#player = Global.player
	#else:
		#print("Player not found")
	#
func process(_delta: float):
	if is_instance_valid(player) and enemy.global_position.distance_to(player.global_position) > enemy.CHASE_DISTANCE:
		Transitioned.emit(self, "EnemyWander")
		
func physics_process(_delta: float):
	if is_instance_valid(player):
		var direction = (player.global_position - enemy.global_position).normalized()
		enemy.velocity = direction * enemy.CHASE_SPEED
		chase_animation.play("monk_chase")
	
