extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print('sup')
	pass # Replace with function body.

func _on_Tween_tween_completed(object, key):
	print('bruh')
	yield(get_tree().create_timer(2.0), "timeout")
	$Tween/NinePatchRect/Label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
