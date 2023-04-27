extends CanvasLayer

onready var player_vars = get_node("/root/GlobalVars")

export(ButtonGroup) var group
func _ready():
	$NinePatchRect/OptionButton.add_item("Random")
	$NinePatchRect/OptionButton.add_item("Audax Construction & Consulting")
	$NinePatchRect/OptionButton.add_item("A&R Fashion")
	$NinePatchRect/OptionButton.add_item("Chariot Motors")
	$NinePatchRect/OptionButton.add_item("Dev's Fast Food")
	$NinePatchRect/OptionButton.add_item("Lunchbox's Retail")
	$NinePatchRect/OptionButton.add_item("Sunny Sky Entertainment")
func _on_Button_pressed():
	var company
	match $NinePatchRect/OptionButton.get_selected_id():
		0:
			company = "Random"
		1:
			company = "1"
		2:
			company = "2"
		3:
			company = "3"
		4:
			company = "4"
		5:
			company = "5"
		6:
			company = "6"
	player_vars.new_name = $NinePatchRect/LineEdit.text	
	player_vars.company_selected = company		
	self.visible = false
	if get_tree().change_scene("res://scenes/main_world.tscn") != OK:
		print("Unexpected error when switching to main world screen")

