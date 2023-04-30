extends CanvasLayer

func _ready():
	$Profit.value = 100
	$PublicImage.value = 100
	$Stakeholder.value = 100
	pass 

func _on_Tween_tween_completed(object, key):
	yield(get_tree().create_timer(15), "timeout")
	fadeOut()


func fadeOut():
	$AnimationPlayer.play("fade_out")

	
func _on_Tween_tween_started(object, key):
	pass 
	


