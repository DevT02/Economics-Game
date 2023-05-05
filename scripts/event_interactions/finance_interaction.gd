extends Area2D

var interaction = "Finance"

func _input(event):
	
	if event.is_action_pressed("game_usage") and len(get_overlapping_bodies()) > 0 and not get_node_or_null("../Area2D/NoteCardEventPlayer/MarginContainer/NinePatchRect").visible == true:
		var player_event = get_node_or_null("../Area2D/NoteCardEventPlayer")
		if player_event and not get_node("/root/GlobalVars").game_over:
			player_event.play(interaction)


