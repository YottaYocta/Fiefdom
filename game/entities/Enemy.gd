extends KinematicBody

enum ENEMYSTATE {
	MOVE,
	DIE,
	ATTACK
}

export var animation_threshold := 0.01
export var dash_threshold := 0.3
export var acceleration := 3
export var friction_coefficient := 0.1
export var dash_acceleration := 100
export var gravity := 10
export var collision_impulse := 5

var last_direction := Vector3.RIGHT
var velocity := Vector3.ZERO
var state: int = ENEMYSTATE.MOVE
var target: KinematicBody

onready var hurtbox = $EntityHurtBox
onready var animated_sprite = $AnimatedSprite3D
onready var animation_player = $AnimationPlayer
onready var enemy_information = $EntityInformation
onready var health_bar = $HealthBar

func _ready():
	animated_sprite.animation = 'walk'
	pass # Replace with function body.

func _process(delta):
	if state == ENEMYSTATE.MOVE:
		var direction := (Vector3(randi() % 3 - 1, randi() % 3 - 1, randi() % 3 - 1) + last_direction).normalized() if randi() % 2 == 0 else Vector3()
		var distance := direction.length()
		if target != null:
			direction = target.global_transform.origin - global_transform.origin
			distance = direction.length()
		if target !=null && distance < dash_threshold:
			velocity += last_direction * dash_acceleration * delta
			animated_sprite.animation = 'attack'
			state = ENEMYSTATE.ATTACK
			hurtbox.set_monitorable(true)
		else:
			velocity += direction.normalized()  * acceleration * delta

			# Animation

			if velocity.rotated(Vector3.UP, -rotation.y).x < -animation_threshold:
				animated_sprite.flip_h = true
			elif velocity.rotated(Vector3.UP, -rotation.y).x > animation_threshold:
				animated_sprite.flip_h = false

			if velocity.length() < animation_threshold:
				animated_sprite.animation = 'idle';
			else:
				animated_sprite.animation = 'walk';


	elif state == ENEMYSTATE.ATTACK:
		if velocity.length() < animation_threshold:
			animated_sprite.animation = 'walk'
			state = ENEMYSTATE.MOVE
			hurtbox.set_monitorable(false)

	velocity = velocity.linear_interpolate(Vector3.ZERO, friction_coefficient)
	velocity = velocity + Vector3.DOWN * gravity * delta
	velocity = move_and_slide(velocity)

	if velocity.length() > animation_threshold:
		last_direction = velocity.normalized()



func _on_SeekArea_body_entered(body:Node):
	if body is KinematicBody && body.is_in_group('player'):
		target = body


func _on_SeekArea_body_exited(body:Node):
	if body is KinematicBody && body.is_in_group('player'):
		target = null

func _on_EntityHitBox_area_entered(area:Area):
	if area is EntityHurtBox:
		enemy_information.take_damage(area.damage)
		animation_player.play('Damage Flash')
		var direction = (area.global_transform.origin - global_transform.origin).normalized() * collision_impulse
		velocity.x -= direction.x
		velocity.z -= direction.z
		velocity.y += (Vector3.UP * collision_impulse).y

func _on_EntityInformation_health_changed(old_health: int, new_health: int):
	health_bar.interpolate(old_health as float / enemy_information.max_health, new_health as float / enemy_information.max_health)


func _on_EntityInformation_dead():
	queue_free()
