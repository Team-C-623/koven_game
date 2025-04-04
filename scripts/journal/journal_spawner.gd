extends Node3D
class_name JournalSpawner
@export var journal_scene : PackedScene
@export var spawn_chance : float = 0.5  # 50% chance to spawn
@export var spawn_height : float = 0.5  # Height above ground

func try_spawn_journal():
	if randf() <= spawn_chance:
		var journal = journal_scene.instantiate()
		
		# Position randomly within spawner area
		var spawn_extents = $CollisionShape3D.shape.extents
		var random_pos = Vector3(
			randf_range(-spawn_extents.x, spawn_extents.x),
			spawn_height,
			randf_range(-spawn_extents.z, spawn_extents.z)
		)
		
		journal.position = random_pos
		add_child(journal)
		return journal
	return null
