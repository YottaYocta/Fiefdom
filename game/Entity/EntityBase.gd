extends KinematicBody

class_name EntityBase

onready var sprite := $AnimatedSprite3D
onready var stats := $EntityStats

var velocity := Vector3.ZERO

func _ready():
	stats.configure(Stats.new())

func move():
	velocity = move_and_slide(velocity)

func apply_constants(delta):
	velocity.y -= Global.gravity * delta
	velocity = velocity.linear_interpolate(Vector3.ZERO, Global.friction)

func _physics_process(delta):
	apply_constants(delta)
	move()
