extends Label

var combo = 0

func _on_mob_squashed():
	combo += 1
	text = "COMBO: %s" % combo


func _on_player_landed() -> void:
	combo = 0
	text = "COMBO: %s" % combo
