extends Area2D

func _input(event):

	if event.is_action_pressed("game_usage") and len(get_overlapping_bodies()) > 0:
		find_and_use_event()
		
func find_and_use_event():
	var player_event = get_node_or_null("NoteCardEventPlayer")
	if player_event:
		player_event.play()
