extends Control

@onready var card_hand: Control = $"."
@onready var card: Sprite2D = $Card
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerManager.use_item.connect(_on_item_use)




func _on_item_use(slot_data: SlotData):
	card.texture = slot_data.item_data.texture
	card_hand.visible = true
	animation_player.play("full_card_use")
	await get_tree().create_timer(1.15).timeout
	SoundManager.play_card_burn()
	await animation_player.animation_finished
	
	card_hand.visible = false
