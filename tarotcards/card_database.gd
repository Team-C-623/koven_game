class_name CardDatabase extends Resource

const CARD_WEIGHTS := {
	ItemData.Rarity.COMMON: 67,   # 70% chance
	ItemData.Rarity.RARE: 33,     # 25% chance
	ItemData.Rarity.SPECIAL: 0    # 5% chance
}

static var common_cards: Array[ItemData] = [
	preload("res://tarotcards/resources/judgement.tres"),
	preload("res://tarotcards/resources/the_high_priestess.tres"),
	preload("res://tarotcards/resources/the_devil.tres")
	# ... more common cards
]

static var rare_cards: Array[ItemData] = [
	preload("res://tarotcards/resources/death.tres"),
	preload("res://tarotcards/resources/wheel_of_fortune.tres"),
	preload("res://tarotcards/resources/the_hanged_man.tres")
	# ... more rare cards
	
]

static var special_cards: Array[ItemData] = [
	#preload("res://tarotcards/resources/temp_special.tres")
	# ... more special cards
]
