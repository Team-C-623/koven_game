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
	elif name == "The High Priestess":
		TarotManager.use_high_priestess()
	elif name == "The Hanged Man":
		TarotManager.use_the_hanged_man()
	elif name == "The Devil":
		TarotManager.use_the_devil()
		
	SoundManager.play_card_burn()
	
