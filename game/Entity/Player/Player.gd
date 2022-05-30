extends EntityBase

func _ready():
	var player_stats = Stats.new()
	player_stats.max_health = PlayerStore.max_health
	player_stats.health = PlayerStore.health
	player_stats.speed = PlayerStore.speed
	player_stats.damage = PlayerStore.damage
	stats.configure(player_stats)
	print('player instance stats:')
	stats.debug()

func _process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed('ui_left'):
		direction.x -= 1
	if Input.is_action_pressed('ui_right'):
		direction.x += 1

	velocity += direction.normalized().rotated(Vector3.UP, rotation.y) * stats.speed * delta
