extends Spatial

onready var foreground = $Positive
onready var tween = $Tween
onready var animation_player = $AnimationPlayer


func _ready():
	pass  # Replace with function body.


func interpolate(origin: float, target: float):
	animation_player.stop()
	animation_player.play("Show")
	tween.interpolate_property(
		foreground,
		"scale:x",
		max(0, origin),
		max(0, target),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
