extends Node

class_name EntityStats

var max_health: float
var health: float
var speed: float
var damage: float

func configure(stats: Stats): 
	max_health = stats.max_health
	health = stats.health
	speed = stats.speed
	damage = stats.damage

func debug():
	var output_string = '\nmax_health: %s\nhealth: %s\nspeed: %s\ndamage: %s'
	print(output_string % [max_health, health, speed, damage])
