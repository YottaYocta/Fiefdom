extends EntityStats

export (Resource) var stats : Resource

func _ready():
	.configure(stats)
	var output_string = 'player store initialized with: \nhealth %s \nspeed %s \ndamage %s'
	print(output_string % [health, speed, damage])
