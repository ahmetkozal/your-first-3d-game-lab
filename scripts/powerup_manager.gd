extends Node

@onready var player: Player = $".."

func use_speed_powerup():
	player.speed += 10

	await get_tree().create_timer(5).timeout

	player.speed -= 10
