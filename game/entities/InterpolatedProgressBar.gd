tool
extends Spatial

onready var progress_bar = $Viewport/TextureProgress
onready var animation_player = $AnimationPlayer
onready var tween = $Tween

export (Color) var background_color : Color setget set_background
export (Color) var progress_color : Color setget set_progress
export (float) var value: float setget set_value

func _ready():
	progress_bar.tint_under = background_color
	progress_bar.tint_progress = progress_color

func set_background(color: Color):
	background_color = color
	if Engine.editor_hint:
		progress_bar.tint_under = color

func set_progress(color: Color):
	progress_color = color
	if Engine.editor_hint:
		progress_bar.tint_progress = color

func set_value(val: float):
	value = val
	if Engine.editor_hint:
		var previous_value = progress_bar.value
		progress_bar.value = value
		interpolate(previous_value, value)


func interpolate(origin: float, target: float): 
	value = target
	animation_player.stop()
	animation_player.play("Show and Hide")
	tween.interpolate_property(
		progress_bar,
		"value",
		max(0, origin),
		max(0, value),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()

