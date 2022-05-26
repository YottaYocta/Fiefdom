extends Spatial

onready var foreground = $Foreground
onready var tween = $Tween

func _ready():
	pass # Replace with function body.

func interpolate(origin: float, target: float):
	tween.interpolate_property(
		foreground,
		"scale:x", 
		max(0, origin),
		max(0, target),
		1, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
	)
	tween.start()

