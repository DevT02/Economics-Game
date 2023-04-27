extends CanvasLayer

func _ready():
	pass 

func _on_Tween_tween_completed(object, key):
	yield(get_tree().create_timer(3.75), "timeout")
	print("fading out")
	fadeOut()


func fadeOut():
	print('fading..')
	$AnimationPlayer.play("fade_out")

	
func _on_Tween_tween_started(object, key):
	pass 
	


