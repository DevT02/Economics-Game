extends Control

export(ButtonGroup) var group
var company
var names
var items

func _ready():
	$MarginContainer/AdvancedSelection.visible = false
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")

func button_pressed():
	if group.get_pressed_button() == group.get_buttons()[0]:
		get_tree().change_scene("res://scenes/main_world.tscn")
	elif group.get_pressed_button() == group.get_buttons()[1]:
		get_tree().change_scene("res://scenes/main_world.tscn")
		print(name)


func backToScreen(name, company, items):
	for i in group.get_buttons():
		i.disabled = false
	company = company
	name = name
	items = items
	
func _on_AdvancedSettingsButton_pressed():
	for i in group.get_buttons():
		i.disabled = true
	$MarginContainer.modulate.a = 0.1
	$MarginContainer/AdvancedSelection.visible = true


