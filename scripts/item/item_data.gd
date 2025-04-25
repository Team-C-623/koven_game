extends Resource
class_name ItemData

enum Rarity { COMMON, RARE, SPECIAL }
@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture
@export var cost: int
@export var duration: float
@export var rarity: Rarity

func use(_target) -> void:
	if name == "Judgement":
		TarotManager.use_judgement(self)
	elif name == "Wheel of Fortune":
		TarotManager.use_wheel_of_fortune(self)
	elif name == "Death":
		TarotManager.use_death()
		
	SoundManager.play_card_burn()
	
