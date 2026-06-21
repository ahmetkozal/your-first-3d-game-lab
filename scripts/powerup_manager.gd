extends Node

@onready var player: Player = $".."

func use_speed_powerup(amount: int):
	player.speed += amount
	await get_tree().create_timer(5).timeout
	player.speed -= amount


func use_higher_jump(amount: int):
	player.jump_impulse += amount
	await get_tree().create_timer(5).timeout
	player.jump_impulse -= amount

func use_immortal():
	player.can_die = false
	await get_tree().create_timer(5).timeout
	player.can_die = true
