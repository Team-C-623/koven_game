class_name JournalUIButton extends TextureButton

var journal_data: JournalEntry : set = set_journal_data

@onready var label: Label = $Label
@onready var journal_image: TextureRect = $ItemImage

func _ready() -> void:
	journal_image.texture = null
	label.text = ""
	focus_entered.connect(journal_focus)

func set_journal_data(new_journal: JournalEntry):
	journal_data = new_journal
	if journal_data == null:
		return
	journal_image.texture = new_journal.texture
	label.text = new_journal.title

func journal_focus():
	if journal_data != null:
		Journal.update_journal_description(journal_data)
		SoundManager.play_page_turn()
