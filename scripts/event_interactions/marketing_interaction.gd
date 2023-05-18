extends Area2D

var interaction = "Marketing"
var seeked = false
onready var vars = get_node("../Area2D/EffectsPopUp/")

func _input(event):
	if event.is_action_pressed("game_usage") and len(get_overlapping_bodies()) > 0 and not get_node_or_null("../Area2D/NoteCardEventPlayer/MarginContainer/NinePatchRect").visible == true:
		var player_event = get_node_or_null("../Area2D/NoteCardEventPlayer")
		if player_event and not get_node("/root/GlobalVars").game_over:
			player_event.play(interaction)
	elif event.is_action_pressed("game_usage") and get_node_or_null("../Area2D/EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").is_visible():
		if vars.currentlyWaiting && get_node_or_null("../Area2D/EffectsPopUp/Tween/MarginContainer/").modulate.a8 > 150 && !get_node_or_null("../Area2D/EffectsPopUp/Tween/").is_active():
#			print("tween is not active, and margin container is visible.")
			get_node_or_null("../Area2D/EffectsPopUp/Tween/").emit_signal("tween_completed", null, null)
			vars.currentlyWaiting = false
		else:
			get_node_or_null("../Area2D/EffectsPopUp/Tween/").seek(100)
			get_node_or_null("../Area2D/EffectsPopUp/Tween/").emit_signal("tween_completed", null, "skipped")
			vars.currentlyWaiting = true




		

	


