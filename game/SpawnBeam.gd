extends CSGMesh

onready var animation_player = $AnimationPlayer

signal spawn


func beam_at(position: Vector3):
	global_transform.origin.x = position.x
	global_transform.origin.z = position.z
	animation_player.play("SpawnBeam")


func emit_spawn():
	emit_signal("spawn")
