extends Node
@onready var sound_effects_bank: AkBank = $SoundEffects
@onready var music_bank: AkBank = $Music
@onready var ak_event_3d: AkEvent3D = $AkEvent3D
@onready var enter_castle_event: AkEvent3D = $enter_castle  # Changed to regular AkEvent if not spatial


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sound_effects_bank.load_bank()
	music_bank.load_bank()
	Wwise.set_state("AMBIENCE_FLOOR","FLOOR1")
	
func _process(_delta: float) -> void:
	if PlayerManager.player:
		if PlayerManager.is_in_trial_room == false:
			Wwise.set_rtpc_value("Health", PlayerManager.player.health_component.health,self)
		else:
			Wwise.set_rtpc_value("Health", 100,self)

func play_footsteps():
	Wwise.post_event_id(AK.EVENTS.FOOTSTEPS_01, self)

func play_card_burn():
	Wwise.post_event_id(AK.EVENTS.TAROTBURN, self)

func play_page_turn():
	Wwise.post_event_id(AK.EVENTS.JOURNALPAGETURN, self)
	
func play_enemy_death():
	Wwise.post_event_id(AK.EVENTS.ENEMY_DEATH,self)
	#pass

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
	
func play_nun_projectile(): #not used, event node attached to nun scene is posting event
	Wwise.post_event_id(AK.EVENTS.ENEMY_ITEM_THROWS,self)

func play_menu_boop():
	Wwise.post_event_id(AK.EVENTS.MENU_BOOP,self)

func play_text_scrolling():
	Wwise.post_event_id(AK.EVENTS.TEXT_SCROLL_TRIMMED,self)
	pass

func play_jury_whispers():
	Wwise.post_event_id(AK.EVENTS.JURY_WHISPERS,self)

func stop_jury_whispers():
	Wwise.execute_action_on_event_id(
		AK.EVENTS.JURY_WHISPERS,
		AkUtils.AkActionOnEventType.AK_ACTION_ON_EVENT_STOP, # stop event enum
		self, # gameobject
		2000, # fade out time (ms)
		AkUtils.AkCurveInterpolation.AK_CURVE_LINEAR # curve interpolation enum
	)
	
func play_shackles_off():
	Wwise.post_event_id(AK.EVENTS.SHACKLES_OFF,self)

func play_trial_room_failed():
	Wwise.post_event_id(AK.EVENTS.TRIAL_ROOM_FAILED,self)

func stop_trial_room_failed():
	Wwise.execute_action_on_event_id(
		AK.EVENTS.TRIAL_ROOM_FAILED,
		AkUtils.AkActionOnEventType.AK_ACTION_ON_EVENT_STOP, # stop event enum
		self, # gameobject
		1, # fade out time (ms)
		AkUtils.AkCurveInterpolation.AK_CURVE_LINEAR # curve interpolation enum
	)

func stop_on_death():
	Wwise.execute_action_on_event_id(
		AK.EVENTS.ENEMY_ITEM_THROWS,
		AkUtils.AkActionOnEventType.AK_ACTION_ON_EVENT_STOP, # stop event enum
		self, # gameobject
		1, # fade out time (ms)
		AkUtils.AkCurveInterpolation.AK_CURVE_LINEAR # curve interpolation enum
	)
	Wwise.execute_action_on_event_id(
		AK.EVENTS.PLAYER_TAKINGDAMAGE,
		AkUtils.AkActionOnEventType.AK_ACTION_ON_EVENT_STOP, # stop event enum
		self, # gameobject
		1, # fade out time (ms)
		AkUtils.AkCurveInterpolation.AK_CURVE_LINEAR # curve interpolation enum
	)

func play_gavel():
	Wwise.post_event_id(AK.EVENTS.TRIAL_ROOM_GAVEL,self)
	
func play_mad_judge():
	Wwise.post_event_id(AK.EVENTS.JUDGE_DIALOGUE_SILENCE,self)

func play_shackles_on():
	Wwise.post_event_id(AK.EVENTS.SHACKLES_ON,self)

func play_boss_knife():
	Wwise.post_event_id(AK.EVENTS.BOSS_KNIFE_ATTACKS,self)

func play_witch_dialogue():
	Wwise.post_event_id(AK.EVENTS.WITCH_DIALOGUE,self)

func play_soulmother_dialogue():
	Wwise.post_event_id(AK.EVENTS.SOULMOTHER_DIALOGUE,self)

func play_journal_pickup():
	Wwise.post_event_id(AK.EVENTS.JOURNAL_PICKUP,self)

func play_journal_open():
	Wwise.post_event_id(AK.EVENTS.JOURNAL_OPEN,self)
	
func play_journal_close():
	Wwise.post_event_id(AK.EVENTS.JOURNAL_CLOSE,self)

# MUSIC
func play_castle_music(_floor_state: String = "floor1"): # called in main.gd (_entered)
	var _switch_result = Wwise.set_switch("FLOOR_LEVEL","FLOOR1", self)
	Wwise.post_event_id(AK.EVENTS.ENTER_CASTLE, self)
	pass

func play_main_menu_music(): # called in start_screen script
	Wwise.post_event_id(AK.EVENTS.MAIN_MENU,self)
	
func play_start_music(): #called in catacombs.gd 
	Wwise.post_event_id(AK.EVENTS.MAP_LOAD,self)

func play_trial_room_music(): # called in trialroom_1.gd 
	Wwise.set_state("PLAYER_STATE", "ALIVE")
	Wwise.set_state("LOCATION","TRIAL_ROOM")
	await get_tree().process_frame
	Wwise.post_event_id(AK.EVENTS.ENTER_TRIAL_ROOM,self)

func play_enemy_aggro():
	Wwise.post_event_id(AK.EVENTS.ENEMY_AGGRO,self)
	
func play_enemy_safe(): 
	Wwise.post_event_id(AK.EVENTS.ENEMY_SAFE,self)
	pass
	
func play_defeated(): # called in health_component.gd
	Wwise.set_state("PLAYER_STATE", "DEFEATED")
	Wwise.post_event_id(AK.EVENTS.DEFEATED,self)

func play_respawn():
	Wwise.post_event_id(AK.EVENTS.RESPAWN,self)

func play_boss_music(): #needs to be added
	Wwise.set_state("LOCATION", "BOSS")
	Wwise.post_event_id(AK.EVENTS.ENTER_BOSS_ROOM,self)
	
func play_victory(): #needs to be added
	Wwise.post_event_id(AK.EVENTS.VICTORY,self)

func play_queue_credits(): #not called
	Wwise.set_state("LOCATION","credits")
	Wwise.post_event_id(AK.EVENTS.QUEUE_CREDITS,self)
