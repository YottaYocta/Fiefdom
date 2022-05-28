extends Spatial

export(PackedScene) var enemy_scene: PackedScene
export(int) var difficulty := 10
export(float) var camera_speed := 0.5
export(float) var camera_friction := 0.01
export(float) var camera_dist := 10.0
export(Vector3) var camera_displacement := Vector3(0, 0.2, 1)

var spawn_location: Vector3
var rotation_target := 45.0
var rotation_actual := 0.0

onready var player = $Player
onready var spotlight = $Camera/SpotLight
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
	if Input.is_action_just_pressed('ui_left'):
		rotation_target += 90
	if Input.is_action_just_pressed('ui_right'):
		rotation_target -= 90 

	rotation_actual = lerp(rotation_actual, rotation_target, camera_friction) 
	player.rotation.y = deg2rad(rotation_actual) 

	var target_camera_location: Vector3 = (
		player.global_transform.origin
		+ camera_cast.cast_to.rotated(Vector3.UP, player.rotation.y)
	)
	spotlight.look_at(player.global_transform.origin, Vector3.UP)

	var camera_difference = target_camera_location - camera.global_transform.origin
	camera.look_at_from_position(
		camera.global_transform.origin.linear_interpolate(
			camera.global_transform.origin + camera_difference, camera_speed
		),
		player.global_transform.origin,
		Vector3.UP
	)


func _on_EnemyTimer_timeout():
	difficulty -= 1
	if difficulty <= 0:
		$EnemyTimer.stop()
	spawn_location = spawnpoints[randi() % spawnpoints.size()].transform.origin
	spawn_beam.beam_at(spawn_location)


func _spawn_enemy():
	var enemy = enemy_scene.instance()
	enemy.transform.origin = spawn_location
	enemy.rotation_degrees.y = 45
	add_child(enemy)


func _on_Player_attack():
	animation_player.stop()
	animation_player.play("Player Attack")
