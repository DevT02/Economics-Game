extends Button

export(ButtonGroup) var group2

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(group.get_buttons())
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")

func button_pressed():
	if group.get_pressed_button() == group.get_buttons()[0]:
		get_node_or_null("MarginContainer").modulate.a = 255
		self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
