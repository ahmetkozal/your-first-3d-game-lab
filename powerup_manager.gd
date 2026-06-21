extends Node
@onready var player: Player = $".."
func use_speed_powerup():
	var powerup_dur: int = 10
	player.speed +=6
	await get_tree().create_timer(powerup_dur).timeout
	player.speed -=10
	
