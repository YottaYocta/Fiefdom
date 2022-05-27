extends Spatial

export(PackedScene) var enemy_scene: PackedScene
export(int) var difficulty: int
export(float) var camera_speed := 0.7
export(float) var camera_rotational_speed := 15.0
export(float) var camera_friction := 0.1
export(float) var camera_dist := 1.0
export(Vector3) var camera_displacement := Vector3(0, 0.2, 1)

var spawn_location: Vector3
var rotational_velocity := 0.0

onready var player = $Player
onready var view_target = $Player/ViewTarget
onready var camera_cast = $Player/RayCast
onready var camera = $Camera
onready var spawn_beam = $SpawnBeam
onready var animation_player = $AnimationPlayer
onready var spawnpoints = [
	$SpawnPoints/SpawnPoint,
	$SpawnPoints/SpawnPoint2,
	$SpawnPoints/SpawnPoint3,
	$SpawnPoints/SpawnPoint4,
	$SpawnPoints/SpawnPoint5,
	$SpawnPoints/SpawnPoint6,
	$SpawnPoints/SpawnPoint7,
	$SpawnPoints/SpawnPoint8,
]


func _ready():
	randomize()
	camera_cast.cast_to = camera_displacement.normalized() * camera_dist


func _process(delta):
	if Input.is_action_pressed("ui_left"):
		rotational_velocity += camera_rotational_speed
	if Input.is_action_pressed("ui_right"):
		rotational_velocity -= 10

	player.rotate_y(deg2rad(rotational_velocity * delta))
	rotational_velocity = lerp(rotational_velocity, 0, camera_friction)

	var target_camera_location: Vector3
	if camera_cast.is_colliding():
		target_camera_location = camera_cast.get_collision_point()
	else:
		target_camera_location = (
			player.global_transform.origin
			+ camera_cast.cast_to.rotated(Vector3.UP, player.rotation.y)
		)

	var camera_difference = target_camera_location - camera.global_transform.origin
	camera.look_at_from_position(
		camera.global_transform.origin.linear_interpolate(
			camera.global_transform.origin + camera_difference, camera_speed
		),
		view_target.global_transform.origin,
		Vector3.UP
	)


func _on_EnemyTimer_timeout():
	difficulty -= 1
	if difficulty <= 0:
		$EnemyTimer.stop()
	spawn_location = spawnpoints[randi() % spawnpoints.size()].global_transform.origin
	spawn_beam.beam_at(spawn_location)


func _spawn_enemy():
	var enemy = enemy_scene.instance()
	enemy.transform.origin = spawn_location
	enemy.rotation_degrees.y = 45
	add_child(enemy)


func _on_Player_attack():
	animation_player.stop()
	animation_player.play("Player Attack")
