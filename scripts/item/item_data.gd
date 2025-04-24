extends Resource
class_name ItemData

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture
@export var cost: int
@export var duration: float


func use(_target) -> void:
	if name == "Judgement":
		TarotManager.use_judgement(self)
	elif name == "Wheel of Fortune":
		TarotManager.use_wheel_of_fortune(self)
		
	SoundManager.play_card_burn()
	
