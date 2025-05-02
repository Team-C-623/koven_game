extends Node3D
class_name JournalSpawner
@export var journal_scene : PackedScene
@export var spawn_chance : float = 1.0  # 50% chance to spawn
@export var spawn_height : float = 0.5  # Height above ground
@export var real_position: Vector3

func _ready() -> void:
	try_spawn_journal()

func try_spawn_journal():
	if randf() <= spawn_chance:
		var journal = journal_scene.instantiate()
		
		# Position randomly within spawner area
		var spawn_extents = Vector3(4, 0, 4)
		var random_pos = Vector3(
			randf_range(-spawn_extents.x, spawn_extents.x),
			spawn_height,
			randf_range(-spawn_extents.y, spawn_extents.z)
		)
		print(real_position)
		journal.position = random_pos
		get_tree().get_current_scene().add_child(journal)
		return journal
	return null
