extends State
class_name BossChase

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player Groups")
	#enter_state()

func process(_delta: float):
	if is_instance_valid(player) and enemy.global_position.distance_to(player.global_position) < enemy.GRAB_DISTANCE:
		#enemy.dancing = false
		#Transitioned.emit(self, "BossGrab")
		pass
		
#func enter_state():
	#enemy.dancing = true
	#print("In BossChase - enemy.dancing: ", enemy.dancing)
		
func physics_process(_delta: float):
	if is_instance_valid(player):
		var direction = (player.global_position - enemy.global_position).normalized()
		enemy.velocity = direction * enemy.CHASE_SPEED
		
		#if enemy.dancing:
			#enemy.sprite.rotate_y(_delta)
		#else:
			#enemy.velocity = Vector3.ZERO
