extends Node3D
class_name HealthComponent

@export var MAX_HEALTH := 0.0
@export var auto_free_on_death := true
@export var damage_modifier: float = 1.0

signal health_changed(current_health: float, max_health: float)
signal nun_die
signal monk_die
#signal boss2_die
signal died
signal damaged


var health : float
var is_dead := false

func _ready():
	health = MAX_HEALTH
	
func damage(attack: Attack):
	health -= (attack.attack_damage * damage_modifier)
	damaged.emit()
	if is_dead:
		return
	
	health_changed.emit(health, MAX_HEALTH)
	if health > 0:
		# play damage sound based on character type
		if get_parent() is Player:
			SoundManager.play_player_damage()
		else:
			SoundManager.play_enemy_damage_sound()
	else:
		is_dead = true
		if get_parent().is_in_group("Enemies Group"):
			SoundManager.play_enemy_death()
			if get_parent() is Monk:
				monk_die.emit()
				Currency.add_currency(5)
			elif get_parent() is Nun:
				nun_die.emit()
				Currency.add_currency(10)
			# for boss
			else:
				get_parent().call_deferred("queue_free")
		# emit death signal when player dies and play sounds
		if get_parent() is Player:
			died.emit()
			SoundManager.stop_on_death()
			SoundManager.play_defeated()

func reset_health():
	health = MAX_HEALTH
	is_dead = false
	emit_signal("health_changed", health, MAX_HEALTH) 
