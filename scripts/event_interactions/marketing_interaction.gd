extends Area2D

var interaction = "Marketing"

func _input(event):
	if event.is_action_pressed("game_usage") and len(get_overlapping_bodies()) > 0 and not get_node_or_null("../Area2D/NoteCardEventPlayer/MarginContainer/NinePatchRect").visible == true:
		var player_event = get_node_or_null("../Area2D/NoteCardEventPlayer")
		if player_event:
			player_event.play(interaction)
	elif event.is_action_pressed("game_usage") and get_node_or_null("../Area2D/EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").is_visible():
		get_node_or_null("../Area2D/EffectsPopUp/Tween/").seek(100000)
		print("completed")
		get_node_or_null("../Area2D/EffectsPopUp/Tween/").emit_signal("tween_completed")



		

	


