extends Spatial

export (PackedScene) var enemy_scene: PackedScene
export (int) var difficulty: int

onready var animation_player = $AnimationPlayer
onready var spawn_beam = $SpawnBeam
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
var spawn_location: Vector3

func _ready():
	randomize()


func _on_EnemyTimer_timeout():
	difficulty -= 1
	if (difficulty <= 0): 
		$EnemyTimer.stop()
	spawn_location = spawnpoints[randi() % spawnpoints.size()].global_transform.origin
	spawn_beam.global_transform.origin.x = spawn_location.x
	spawn_beam.global_transform.origin.z = spawn_location.z
	animation_player.play('SpawnBeam')
	

func _spawn_enemy():
	var enemy = enemy_scene.instance()
	enemy.global_transform.origin = spawn_location
	enemy.rotation_degrees.y = 45
	add_child(enemy)
