extends Node3D

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var pivot:Node3D = $Pivot

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var my_random_number_rotation:float = rng.randf_range(-1.0, 1.0)
	animation_player.speed_scale = my_random_number_rotation
	
	var my_random_number_height:float = rng.randf_range(0.0, 2.0)
	pivot.position = Vector3(0.009,my_random_number_height,0.0)
	
	
