extends CanvasLayer

export(ButtonGroup) var group
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time

func _ready():
	print("entered.")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	print("yo pressed")
	self.visible = false
	get_node_or_null("../").modulate.a = 1
	get_node_or_null("../../").backToScreen()
	pass # Replace with function body.
