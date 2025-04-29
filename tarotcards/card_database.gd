class_name CardDatabase extends Resource

const CARD_WEIGHTS := {
	ItemData.Rarity.COMMON: 50,   # 70% chance
	ItemData.Rarity.RARE: 35,     # 25% chance
	ItemData.Rarity.SPECIAL: 15    # 5% chance
}

static var common_cards: Array[ItemData] = [
	preload("res://tarotcards/resources/judgement.tres"),
	# ... more common cards
]

static var rare_cards: Array[ItemData] = [
	preload("res://tarotcards/resources/death.tres"),
	preload("res://tarotcards/resources/wheel_of_fortune.tres")
	# ... more rare cards
]

static var special_cards: Array[ItemData] = [
	preload("res://tarotcards/resources/temp_special.tres")
	# ... more special cards
]
