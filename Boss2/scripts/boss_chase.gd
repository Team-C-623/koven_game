extends State
class_name BossChase

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null
@onready var lasso_animation: AnimationPlayer = $"../../LassoAnimation"

var grab_cooldown := 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")
	reset_grab_cooldown()

func reset_grab_cooldown():
	grab_cooldown = randf_range(2.0, 5.0)

func process(_delta: float):
	if is_instance_valid(player):
		var distance = enemy.global_position.distance_to(player.global_position)
		grab_cooldown -= _delta
		if distance < enemy.GRAB_DISTANCE and grab_cooldown <= 0.0:
			if randf() < 0.95:
				Transitioned.emit(self, "BossGrab")
			reset_grab_cooldown()
		
func physics_process(_delta: float):
	if is_instance_valid(player):
		#lasso_animation.play("boss_grab")
		var direction = (player.global_position - enemy.global_position).normalized()
		enemy.velocity = direction * enemy.CHASE_SPEED
		
