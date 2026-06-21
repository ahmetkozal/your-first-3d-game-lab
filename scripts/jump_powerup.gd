extends Area3D

signal used

@onready var animation_player: AnimationPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.

func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))


func _on_timer_timeout() -> void:
	animation_player.play("powerup_queue_free_anim")
	await animation_player.animation_finished
	queue_free()

func use():
	used.emit()
	animation_player.play("powerup_queue_free_anim")
	await animation_player.animation_finished
	queue_free()
	
	


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.get_node("PowerupManager").use_higher_jump(10)
		queue_free()
