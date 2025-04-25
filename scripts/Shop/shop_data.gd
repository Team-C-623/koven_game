class_name ShopData extends Resource

@export var shop_items: Array[ItemData]
@export var max_shop_size := 5

func generate_shop():
	shop_items.clear()
	
	for i in range(max_shop_size):
		var rarity = get_weighted_rarity()
		var card = get_random_card(rarity)
		shop_items.append(card)

func get_weighted_rarity() -> ItemData.Rarity:
	var weights = CardDatabase.CARD_WEIGHTS
	var total_weight = weights.values().reduce(func(a, b): return a + b)
	var roll = randi_range(1, total_weight)
	
	var cumulative = 0
	for rarity in weights:
		cumulative += weights[rarity]
		if roll <= cumulative:
			return rarity
	return ItemData.Rarity.COMMON  # fallback

func get_random_card(rarity: ItemData.Rarity) -> ItemData:
	match rarity:
		ItemData.Rarity.COMMON:
			return CardDatabase.common_cards.pick_random().duplicate()
		ItemData.Rarity.RARE:
			return CardDatabase.rare_cards.pick_random().duplicate()
		_:
			return CardDatabase.special_cards.pick_random().duplicate()
