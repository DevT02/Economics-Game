extends Control

export(ButtonGroup) var group
onready var player_vars = get_node("/root/GlobalVars")


func _ready():

	screen_metrics()
		
func screen_metrics():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)


func _on_NewGameButton_pressed():
	if get_tree().change_scene("res://scenes/characterselectionscreen.tscn") != OK:
		print("Unexpected error when switching to character selection screen")

func _on_Continue_pressed():
	print("pressed button continue")
	if not player_vars.game_over == true:
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
