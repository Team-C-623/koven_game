extends Panel

@onready var title_label = $VBoxContainer/Title
@onready var content_label = $VBoxContainer/Content
@onready var close_button = $VBoxContainer/CloseButton

func _ready():
	visible = false
	close_button.pressed.connect(hide)
	

func display_entry(entry: JournalEntry):
	visible = true
	title_label.text = "Entry #%d" % entry.entry_id
	content_label.text = entry.content
	close_button.text = "Close"
	print(entry.content)
	
