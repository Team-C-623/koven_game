extends Node

var timer : float = 0.0
var timer_active := false

const JUDGEMENT_MODIFIER := 2.0

var judgement_active: bool = false
var wheel_of_fortune_active: bool = false
var rng = RandomNumberGenerator.new()
@onready var main_node = get_node("/root/Main")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()  # Important for different results each run

func _process(delta: float):
	if timer_active:
		timer -= delta
		if judgement_active:
			update_judgement()
		if timer <= 0:
			_on_timer_ended()
			timer_active = false
			
func start_timer(duration: float):
	timer = duration
	timer_active = true
	
func _on_timer_ended():
	if judgement_active:
		end_judgement()
	print("timer ended")

func use_judgement(item_data:ItemData):
	judgement_active = true
	start_timer(item_data.duration)
	
	for node in main_node.get_children(true):
		if node is CharacterBody3D or Player:
			for component in node.get_children(true):
				if component is HealthComponent:
					component.damage_modifier = JUDGEMENT_MODIFIER
					
func end_judgement():
	judgement_active = false
	for node in main_node.get_children(true):
		if node is CharacterBody3D or Player:
			for component in node.get_children(true):
				if component is HealthComponent:
					component.damage_modifier = 1.0
#add damage modifications to new enemies that spawn after use_judegement is called
func update_judgement():
	for node in main_node.get_children(true):
		if node is CharacterBody3D or Player:
			for component in node.get_children(true):
				if component is HealthComponent:
					component.damage_modifier = JUDGEMENT_MODIFIER
					
func use_wheel_of_fortune(item_data: ItemData):
	#randomly increase 1 of 3 stats: +10 damage, +20 health, +2.0 speed
	var random_num = rng.randi_range(0, 2)
	var health_component
	for node in main_node.get_children(true):
			if node is Player:
				for component in node.get_children(true):
					if component is HealthComponent:	
						health_component = component
	if random_num == 0:
		PlayerManager.player.attack_damage += 10
						
	elif random_num == 1:
		for node in main_node.get_children(true):
			if node is Player:
				for component in node.get_children(true):
					if component is HealthComponent:	
						component.MAX_HEALTH += 20
						component.health += 20
		health_component.emit_signal("health_changed",health_component.health,health_component.MAX_HEALTH)
	elif random_num == 2:
		for node in main_node.get_children(true):
			if node is Player:
				node.speed += 2.0
			
				
	print("WHeel of fortune grants: " + str(random_num))
	print("0 = +10 damage, 1 = +20 hp and Max hp, 2 = +2.0 speed") 

func use_death():
	for node in main_node.get_children(true):
			if node is Player:
				for component in node.get_children(true):
					if component is HealthComponent:	
						component.health += component.MAX_HEALTH
						component.emit_signal("health_changed",component.health,component.MAX_HEALTH)



	
	

	
