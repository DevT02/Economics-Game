extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _input(event):
	if event.is_action_pressed("escape"):
		$MarginContainer2/TextureRect.visible = true
	
func _on_Button_mouse_entered():
	$MarginContainer/Button.modulate.a8 = 225
	pass # Replace with function body.


func _on_Button_mouse_exited():
	$MarginContainer/Button.modulate.a8 = 255
	pass # Replace with function body.


func _on_Button_pressed():
	$MarginContainer/Button.modulate.a8 = 100
	pass # Replace with function body.
