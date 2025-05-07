extends Node
class_name State
signal Transitioned(state: State, new_state_name: String)

func _ready():
	Transitioned.emit(self, "EnemyWander")

func enter():
	pass

func exit():
	pass

func _process(_delta: float):
	pass
	
func _physics_process(_delta: float):
	pass
