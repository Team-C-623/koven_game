extends Node
@onready var sound_effects_bank: AkBank = $SoundEffects
@onready var music_bank: AkBank = $Music
@onready var ak_event_3d: AkEvent3D = $AkEvent3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sound_effects_bank.load_bank()
	music_bank.load_bank()


func play_footsteps():
	Wwise.post_event_id(AK.EVENTS.FOOTSTEPS, self)
	
func play_card_burn():
	Wwise.post_event_id(AK.EVENTS.CARDBURN, self)

func play_page_turn():
	Wwise.post_event_id(AK.EVENTS.PAGETURN, self)
	
func play_death_sound():
	Wwise.post_event_id(AK.EVENTS.DEATHSOUND,self)
	
func play_start_music():
	Wwise.post_event_id(AK.EVENTS.MAP_LOAD,self)
	
func stop_start_music():
	#why doesnt it stop
	Wwise.stop_event(AK.EVENTS.MAP_LOAD,0,AkUtils.AkCurveInterpolation.AK_CURVE_LINEAR)
	
