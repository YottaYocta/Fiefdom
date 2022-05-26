extends KinematicBody

enum PLAYERSTATE {
	MOVE,
	DIE,
	ATTACK
}

export var animation_threshold := 0.01
export var dash_threshold := 0.2
export var acceleration := 5
export var friction_coefficient := 0.1
export var dash_acceleration := 400
export var gravity := 10

var last_direction := Vector3.RIGHT
var velocity := Vector3.ZERO
var state: int = PLAYERSTATE.MOVE

onready var hurtbox := $EntityHurtBox
onready var hitbox := $EntityHitBox
onready var animation_player := $AnimationPlayer
onready var player_information := $EntityInformation
onready var health_bar := $HealthBar

func _ready():
	$AnimatedSprite3D.animation = 'walk'
	pass # Replace with function body.

func _process(delta):
	if state == PLAYERSTATE.MOVE:
		if Input.is_action_just_pressed('attack'):
			velocity += last_direction * dash_acceleration * delta
			$AnimatedSprite3D.animation = 'attack'
			state = PLAYERSTATE.ATTACK
			hurtbox.set_monitorable(true)
			hitbox.set_monitoring(false)
		else:
			var direction := Vector3.ZERO
			if Input.is_action_pressed('forward'):
				direction.z -= 1
			if Input.is_action_pressed('backward'): 
				direction.z += 1
			if Input.is_action_pressed('left'):
				direction.x -= 1
			if Input.is_action_pressed('right'):
				direction.x += 1
			
			velocity += direction.normalized().rotated(Vector3.UP, rotation.y)  * acceleration * delta

			# Animation

			if velocity.rotated(Vector3.UP, -rotation.y).x < -animation_threshold:
				$AnimatedSprite3D.flip_h = true
			elif velocity.rotated(Vector3.UP, -rotation.y).x > animation_threshold:
				$AnimatedSprite3D.flip_h = false

			if velocity.length() < animation_threshold:
				$AnimatedSprite3D.animation = 'idle';
			else:
				$AnimatedSprite3D.animation = 'walk';


	elif state == PLAYERSTATE.ATTACK:
		if velocity.length() < dash_threshold:
			$AnimatedSprite3D.animation = 'walk'
			state = PLAYERSTATE.MOVE
			hurtbox.set_monitorable(false)
			hitbox.set_monitoring(true)

	velocity = velocity.linear_interpolate(Vector3.ZERO, friction_coefficient)
	velocity = velocity + Vector3.DOWN * gravity * delta
	velocity = move_and_slide(velocity)

	if velocity.length() > animation_threshold:
		last_direction = velocity.normalized()

func _on_EntityHitBox_area_entered(area:Area):
	if area is EntityHurtBox:
		player_information.take_damage(area.damage)
		animation_player.play('Damaged')
		
func _on_EntityInformation_health_changed(old_health: int, new_health: int):
	health_bar.interpolate(old_health as float / player_information.max_health, new_health as float / player_information.max_health)
