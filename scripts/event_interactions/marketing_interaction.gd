extends Area2D

var interaction = "Marketing"

func _input(event):
	if event.is_action_pressed("game_usage") and len(get_overlapping_bodies()) > 0 and not get_node_or_null("../Area2D/NoteCardEventPlayer/MarginContainer/NinePatchRect").visible == true:
		var player_event = get_node_or_null("../Area2D/NoteCardEventPlayer")
		if player_event:
			player_event.play(interaction)
	elif event.is_action_pressed("game_usage") and get_node_or_null("../Area2D/EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").is_visible():
		if get_node_or_null("../Area2D/EffectsPopUp/AnimationPlayer").get_animation() != "fade_out":
			get_node_or_null("../Area2D/EffectsPopUp/Tween/").seek(1000)
			yield(get_tree().create_timer(3.75), "timeout")
			get_node_or_null("../Area2D/EffectsPopUp/AnimationPlayer").play("fade_out")

		

	


