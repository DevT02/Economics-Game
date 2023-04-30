extends Control

export(ButtonGroup) var group
onready var player_vars = get_node("/root/GlobalVars")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#		"name" : player_vars.new_name,
#		"company" : player_vars.company_selected,
#		"profit" : player_vars.profit, 
#		"stakeholder" : player_vars.stakeholder,
#		"public_img" : player_vars.public_img,
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")
	screen_metrics()
		
func button_pressed():
	if group.get_pressed_button() == group.get_buttons()[0]:
		if get_tree().change_scene("res://scenes/characterselectionscreen.tscn") != OK:
			print("Unexpected error when switching to character selection screen")
	if group.get_pressed_button() == group.get_buttons()[1]:
		var file = File.new()
		if file.file_exists("user://savegame.dat"):
			file.open("user://savegame.dat", File.READ)
			var loaded_dict = file.get_var()
			player_vars.new_name = loaded_dict.name
			player_vars.company_selected = loaded_dict.company
			player_vars.profit = loaded_dict.profit
			player_vars.public_img = loaded_dict.public_img
			player_vars.stakeholder = loaded_dict.stakeholder
			player_vars.character_selected = loaded_dict.character
			if get_tree().change_scene("res://scenes/main_world.tscn") != OK:
				print("Unexpected error when switching to character selection screen")
		else:
			print("No game file found!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func screen_metrics():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)
