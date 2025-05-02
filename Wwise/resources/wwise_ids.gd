class_name AK

class EVENTS:

	const DEFEATED : int = 2791675679
	const ENEMY_AGGRO : int = 352335356
	const ENEMY_SAFE : int = 3717377857
	const ENTER_BOSS_ROOM : int = 3603472999
	const ENTER_CASTLE : int = 2474813288
	const ENTER_CATACOMBS : int = 2762024869
	const ENTER_TRIAL_ROOM : int = 1844506134
	const FINAL_BOSS_PHASE2 : int = 1150116533
	const FLOOR1 : int = 3162820674
	const FLOOR2 : int = 3162820673
	const FLOOR3 : int = 3162820672
	const MAIN_MENU : int = 2005704188
	const MAP_LOAD : int = 780953876
	const QUEUE_CREDITS : int = 931351601
	const RESPAWN : int = 4279841335
	const VICTORY : int = 2716678721
	const WITCH0 : int = 3350869486
	const WITCH1 : int = 3350869487
	const WITCH2 : int = 3350869484
	const WITCH3 : int = 3350869485
	const BOSS_KNIFE_ATTACKS : int = 2119463198
	const ENEMYDAMAGE : int = 1879435608
	const ENEMY_DEATH : int = 1205999388
	const ENEMY_ITEM_THROWS : int = 2450329037
	const FOOTSTEPS_01 : int = 2848855924
	const JOURNALPAGETURN : int = 1639161750
	const JUDGE_DIALOGUE_BY_FIRE : int = 2109575468
	const JUDGE_DIALOGUE_SILENCE : int = 1862952859
	const JURY_WHISPERS : int = 4151276193
	const LASSO_ATTACH : int = 1402229995
	const LASSO_WINDUP : int = 1461666693
	const MENUOPEN : int = 48824776
	const MENU_BOOP : int = 3129090587
	const PLAYER_TAKINGDAMAGE : int = 3625562942
	const SHACKLES_OFF : int = 3057807107
	const SHACKLES_ON : int = 3395044911
	const SHOP_BUY : int = 1495252156
	const TAROTBURN : int = 2451853040
	const TAROTPICKUP : int = 1908595231
	const TEXT_SCROLLING : int = 371816340
	const TRIAL_ROOM_FAILED : int = 2277544205
	const TRIAL_ROOM_GAVEL : int = 866175427
	const WAND_BASIC : int = 2783045536
	const WAND_MISFIRE : int = 80501587
	const WITCH_DIALOGUE : int = 2206927579

class STATES:

	class CATACOMB_WITCHES:
		const GROUP : int = 4243432011
	
		class STATE:
			const NONE : int = 748895195
			const WITCH0 : int = 3350869486
			const WITCH1 : int = 3350869487
			const WITCH2 : int = 3350869484
			const WITCH3 : int = 3350869485

	class LOCATION:
		const GROUP : int = 1176052424
	
		class STATE:
			const BOSS : int = 1560169506
			const CASTLE : int = 129146593
			const CATACOMBS : int = 2966204926
			const MAIN_MENU : int = 2005704188
			const NONE : int = 748895195
			const TRIAL_ROOM : int = 1543475711
			const CREDITS : int = 2201105581

	class PLAYER_STATE:
		const GROUP : int = 4071417932
	
		class STATE:
			const ALIVE : int = 655265632
			const DEFEATED : int = 2791675679
			const NONE : int = 748895195
			const VICTORY : int = 2716678721

	class AMBIENCE_FLOOR:
		const GROUP : int = 2903394062
	
		class STATE:
			const NONE : int = 748895195
			const FLOOR1 : int = 3162820674
			const FLOOR2 : int = 3162820673
			const FLOOR3 : int = 3162820672


class SWITCHES:

	class FINAL_BOSS:
		const GROUP : int = 2345047989
	
		class SWITCH:
			const PHASE1 : int = 3630028971
			const PHASE2 : int = 3630028968

	class GAMEPLAY_SWITCH:
		const GROUP : int = 2702523344
	
		class SWITCH:
			const COMBAT : int = 2764240573
			const EXPLORE : int = 579523862

	class FLOOR_LEVEL:
		const GROUP : int = 3257587070
	
		class SWITCH:
			const FLOOR1 : int = 3162820674
			const FLOOR2 : int = 3162820673
			const FLOOR3 : int = 3162820672

	class WANDSHOTS:
		const GROUP : int = 3734252994
	
		class SWITCH:
			const BASE : int = 1291433366
			const EMPOWERED : int = 542766697


class GAME_PARAMETERS:

	const MUSIC_BACKUP_SIDECHAIN : int = 198116658
	const MUSIC_VOLUME_SLIDER : int = 2872980221
	const SFX_VOLUME_SLIDER : int = 4274270069
	const HEALTH : int = 3677180323
	const SFX_SIDECHAIN : int = 2862064063

class TRIGGERS:
	pass

class BANKS:

	const MUSIC_SOUNDBANK : int = 3589812408
	const SFX_SOUNDBANK : int = 2641024368

class AUX_BUSSES:
	pass

class ACOUSTIC_TEXTURES:

	const ACOUSTIC_BANNER : int = 4168643977
	const ANECHOIC : int = 1873957695
	const BRICK : int = 504532776
	const CARPET : int = 2412606308
	const CONCRETE : int = 841620460
	const CORK_TILES : int = 3195498748
	const CURTAINS : int = 2928161104
	const DRYWALL : int = 3670307564
	const FABRIC : int = 1970351858
	const MOUNTAIN : int = 513139656
	const TILE : int = 2637588553
	const WOOD : int = 2058049674
	const WOOD_BRIGHT : int = 4262522749
	const WOOD_DEEP : int = 1755085759
