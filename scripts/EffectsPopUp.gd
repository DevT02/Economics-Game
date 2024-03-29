extends CanvasLayer
signal tween_completed
var currentlyWaiting = false

func _ready():
	$Tween.connect("tween_completed", self, "on_tween_completed")
	$Profit.value = 75
	$PublicImage.value = 75
	$Stakeholder.value = 75
	pass 


func on_tween_completed(object = null, key = null):
	if currentlyWaiting && object == null && key != null:
		fadeOut()
	else:
		yield(get_tree().create_timer(2.5), "timeout")
		on_tween_completed()


func fadeOut():
	$AnimationPlayer.play("fade_out")
	currentlyWaiting = false

	
func _on_Tween_tween_started(object, key):
	pass 
	


