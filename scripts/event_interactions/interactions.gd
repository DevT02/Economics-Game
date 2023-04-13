extends Area2D

var interaction = "Finance Dept."

func _input(event):
	if event.is_action_pressed("game_usage") and len(get_overlapping_bodies()) > 0 and not get_node_or_null("../Area2D/NoteCardEventPlayer/NinePatchRect").visible == true:
		var player_event = get_node_or_null("NoteCardEventPlayer")
		if player_event:
			player_event.play(interaction)



#func _on_Area2D_body_exited(body):
#	if body.name=="Player" and body in array1:
#		if (array1.find(body) == "marketing_interaction")
#		finance.interact=false
#		array1.erase(body)
#	elif body.name=="Player" and body in array1:
#		marketing.interact=false
#		array1.erase(body)
#	elif body.name=="Player" and body in array1:
#		marketing.interact=false
#		array1.erase(body)

#func find_and_use_event():
#	var player_event = get_node_or_null("NoteCardEventPlayer")
#	if player_event:
#		player_event.play()
#
#var array1=[]

#
#func _on_Area2D_body_exited(body):
#	if body.name=="Player" and body in array1:
#		if (array1.find(body) == "marketing_interaction")
#		finance.interact=false
#		array1.erase(body)
#	elif body.name=="Player" and body in array1:
#		marketing.interact=false
#		array1.erase(body)
#	elif body.name=="Player" and body in array1:
#		marketing.interact=false
#		array1.erase(body)
