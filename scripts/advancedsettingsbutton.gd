extends Button

export(ButtonGroup) var group2


func _ready():
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")

func button_pressed():
	if group.get_pressed_button() == group.get_buttons()[0]:
		get_node_or_null("MarginContainer").modulate.a = 255
		self.visible = false



