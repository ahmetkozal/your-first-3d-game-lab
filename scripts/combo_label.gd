extends Label

var combo:int = 0
signal triple_combo

func _on_mob_squashed():
	combo += 1
	text = "COMBO: %s" % combo
	if combo == 3:
		emit_signal("triple_combo")

func _on_player_landed() -> void:
	combo = 0
	text = "COMBO: %s" % combo
