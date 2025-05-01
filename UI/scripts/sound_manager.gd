extends Node
@onready var sound_effects_bank: AkBank = $SoundEffects
@onready var music_bank: AkBank = $Music
@onready var ak_event_3d: AkEvent3D = $AkEvent3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sound_effects_bank.load_bank()
	music_bank.load_bank()


func play_footsteps():
	Wwise.post_event_id(AK.EVENTS.FOOTSTEPS_01, self)
	
func play_card_burn():
	Wwise.post_event_id(AK.EVENTS.TAROTBURN, self)

func play_page_turn():
	Wwise.post_event_id(AK.EVENTS.JOURNALPAGETURN, self)
	
func play_enemy_death():
	Wwise.post_event_id(AK.EVENTS.ENEMY_DEATH,self)
	pass

func play_enemy_damage_sound():
	Wwise.post_event_id(AK.EVENTS.ENEMYDAMAGE,self)
	
func play_wand_sound():
	Wwise.post_event_id(AK.EVENTS.WAND_BASIC,self)

func play_buy_sound():
	Wwise.post_event_id(AK.EVENTS.SHOP_BUY,self)
	
func play_menu_open():
	Wwise.post_event_id(AK.EVENTS.MENUOPEN,self)
	
func play_tarot_pickup():
	Wwise.post_event_id(AK.EVENTS.TAROTPICKUP,self)
	
func play_player_damage():
	Wwise.post_event_id(AK.EVENTS.PLAYER_TAKINGDAMAGE,self)
	
func play_nun_projectile():
	Wwise.post_event_id(AK.EVENTS.ENEMY_ITEM_THROWS,self)



# MUSIC
func play_castle_music(): #called in entrance.gd
	Wwise.post_event_id(AK.EVENTS.ENTER_CASTLE, self)
	

func play_main_menu_music(): #called in start_screen script
	Wwise.post_event_id(AK.EVENTS.MAIN_MENU,self)
	
func play_start_music(): #called in catacombs.gd
	Wwise.post_event_id(AK.EVENTS.MAP_LOAD,self)

func play_trial_room_music(): #called in dialogue_area.gd 
	Wwise.post_event_id(AK.EVENTS.ENTER_TRIAL_ROOM,self)
	print("PLAYING TRIAL ROOM MUSIC")

func play_catacombs_music():
	Wwise.post_event_id(AK.EVENTS.ENTER_CATACOMBS,self)
	
