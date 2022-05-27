extends Node

signal dead
signal health_changed(old_health, new_health)

export var max_health: int
export var health: int


func _ready():
	pass  # Replace with function body.


func take_damage(damage_taken: int):
	var old_health := health
	health -= damage_taken
	if old_health != health:
		emit_signal("health_changed", old_health, health)
	if health <= 0:
		emit_signal("dead")
