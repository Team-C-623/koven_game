extends Node


const JUDGEMENT_MODIFIER := 2.0
var wof_popup = preload("res://tarotcards/WOF_popup.tscn")
var judgement_active: bool = false
var priestess_active: bool = false
var wheel_of_fortune_active: bool = false
var rng = RandomNumberGenerator.new()
@onready var main_node
var active_timers := {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()  # Important for different results each run

func _process(_delta: float) -> void:
	if judgement_active:
		update_judgement()
	
		
func create_card_timer(card_name: String, duration: float, timeout_func: Callable):
	# Remove existing timer if it exists
	if active_timers.has(card_name):
		active_timers[card_name].queue_free()
	
	# Create new timer
	var timer = Timer.new()
	timer.name = card_name + "_Timer"
	timer.wait_time = duration
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(timeout_func)
	add_child(timer)
	
	# Store reference
	active_timers[card_name] = timer
			


func use_judgement(item_data:ItemData):
	judgement_active = true
	create_card_timer(
		"judgement", 
		item_data.duration, 
		func(): 
			end_judgement()
			active_timers.erase("judgement"))

	apply_judgement_effect()
	
func apply_judgement_effect():
	main_node = get_node("/root/Main")
	for node in main_node.get_children(true):
		if node is CharacterBody3D or Player:
			for component in node.get_children(true):
				if component is HealthComponent:
					component.damage_modifier = JUDGEMENT_MODIFIER
				
func end_judgement():
	judgement_active = false
	active_timers.erase("judgement")
	main_node = get_node("/root/Main")
	for node in main_node.get_children(true):
		if node is CharacterBody3D or Player:
			for component in node.get_children(true):
				if component is HealthComponent:
					component.damage_modifier = 1.0
#add damage modifications to new enemies that spawn after use_judegement is called
func update_judgement():
	main_node = get_node("/root/Main")
	for node in main_node.get_children(true):
		if node is CharacterBody3D or Player:
			for component in node.get_children(true):
				if component is HealthComponent:
					component.damage_modifier = JUDGEMENT_MODIFIER

func use_high_priestess():
	priestess_active = true
	create_card_timer(
		"high_priestess", 
		30.0, 
		func(): 
			end_high_priestess()
			active_timers.erase("high_priestess")
	)
	main_node = get_node("/root/Main")
	for node in main_node.get_children(true):
		if node is Player:
			node.speed += 1.0
			
func end_high_priestess():
	main_node = get_node("/root/Main")
	for node in main_node.get_children(true):
		if node is Player:
			node.speed -= 1.0
			
func end_duration_cards():
	for timer in active_timers:
		active_timers.erase(timer)
func use_the_hanged_man():
	Currency.modifier = 2.0
	create_card_timer(
		"the_hanged_man",
		30.0,
		func():
			end_the_hanged_man()
			active_timers.erase("the_hanged_man")
	)
	

func end_the_hanged_man():
	Currency.modifier = 1.0
	print("hanged man ended")
	
func use_wheel_of_fortune(_item_data: ItemData):
	var effect_message
	#randomly increase 1 of 3 stats: +10 damage, +20 health, +2.0 speed
	var random_num = rng.randi_range(0, 2)
	var health_component
	main_node = get_node("/root/Main")
	for node in main_node.get_children(true):
			if node is Player:
				for component in node.get_children(true):
					if component is HealthComponent:	
						health_component = component
	if random_num == 0:
		PlayerManager.player.attack_damage += 2
		effect_message = "+2 attack damage"
						
	elif random_num == 1:
		for node in main_node.get_children(true):
			if node is Player:
				for component in node.get_children(true):
					if component is HealthComponent:	
						component.MAX_HEALTH += 5
						component.health += 5
		effect_message = "+5 Health and Max Health"
		health_component.emit_signal("health_changed",health_component.health,health_component.MAX_HEALTH)
	elif random_num == 2:
		effect_message = "0.25 speed"
		for node in main_node.get_children(true):
			if node is Player:
				node.speed += 0.25
		
	var popup = wof_popup.instantiate()
	get_tree().root.add_child(popup)
	popup.show_message(effect_message)
	await get_tree().create_timer(3.0).timeout
	popup.queue_free()

func use_death():
	main_node = get_node("/root/Main")
	for node in main_node.get_children(true):
			if node is Player:
				for component in node.get_children(true):
					if component is HealthComponent:	
						component.health = component.MAX_HEALTH
						component.emit_signal("health_changed",component.health,component.MAX_HEALTH)
						
func use_the_devil():
	var heal_value
	main_node = get_node("/root/Main")
	for node in main_node.get_children(true):
			if node is Player:
				for component in node.get_children(true):
					if component is HealthComponent:	
						heal_value = ceil(component.MAX_HEALTH * 0.25)
						component.health += heal_value
						print("Devil Healed:" + str(heal_value))
						component.emit_signal("health_changed",component.health,component.MAX_HEALTH)
