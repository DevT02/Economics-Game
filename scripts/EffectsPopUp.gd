extends CanvasLayer


func _on_Tween_tween_completed(object, key):
	yield(get_tree().create_timer(2.0), "timeout")
	$Tween/NinePatchRect/Label.visible = false

