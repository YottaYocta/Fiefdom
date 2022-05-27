extends CSGMesh

onready var animation_player = $AnimationPlayer

signal spawn

func _ready():
	visible = false

func beam_at(position: Vector3):
	transform.origin.x = position.x
	transform.origin.z = position.z
	animation_player.play("SpawnBeam")


func emit_spawn():
	emit_signal("spawn")
