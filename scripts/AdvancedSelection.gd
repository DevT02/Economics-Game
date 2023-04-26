extends CanvasLayer

onready var player_vars = get_node("/root/GlobalVars")

export(ButtonGroup) var group
func _ready():
	$NinePatchRect/OptionButton.add_item("Random")
	$NinePatchRect/OptionButton.add_item("Tech")
	$NinePatchRect/OptionButton.add_item("Dev's Fast Food")
	$NinePatchRect/OptionButton.add_item("A&R Fashion")
	$NinePatchRect/OptionButton.add_item("Chariot Motors")
	$NinePatchRect/OptionButton.add_item("Retail")
	$NinePatchRect/OptionButton.add_item("Entertainment")
func _on_Button_pressed():
	var company
	match $NinePatchRect/OptionButton.get_selected_id():
		0:
			company = "Random"
		1:
			company = "Tech"
		2:
			company = "Dev's Fast Food"
	player_vars.new_name = $NinePatchRect/LineEdit.text			
	self.visible = false
	get_tree().change_scene("res://scenes/main_world.tscn")
