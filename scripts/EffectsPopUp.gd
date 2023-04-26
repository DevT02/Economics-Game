extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Tween_tween_completed(object, key):
	yield(get_tree().create_timer(3.75), "timeout")
	print("fading out")
	fadeOut()

func fadeOut():
	print('fading..')
	$AnimationPlayer.play("fade_out")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Tween_tween_started(object, key):
	pass # Replace with function body.


