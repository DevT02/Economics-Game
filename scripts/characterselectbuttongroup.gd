extends Control

export(ButtonGroup) var group


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/AdvancedSelection.visible = false
	print(group.get_buttons())
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")

func button_pressed():

	if group.get_pressed_button() == group.get_buttons()[0]:
		get_tree().change_scene("res://scenes/main_world.tscn")
	elif group.get_pressed_button() == group.get_buttons()[1]:
		get_node_or_null("/root/")
		get_tree().change_scene("res://scenes/main_world.tscn")
	elif group.get_pressed_button() == group.get_buttons()[2]:
		for i in group.get_buttons():
			i.disabled = true
		$MarginContainer.modulate.a = 0.1
		$MarginContainer/AdvancedSelection.visible = true

func backToScreen(name, company):
	for i in group.get_buttons():
		i.disabled = false


