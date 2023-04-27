extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player_vars = get_node("/root/GlobalVars")
# Called when the node enters the scene tree for the first time.
func _ready():
	notReady()

func notReady():
	$MarginContainer2.visible = false
	$MarginContainer2.margin_left = -980
	$MarginContainer2.margin_top = 644
	$MarginContainer2.margin_right = -1553
	$MarginContainer2.margin_bottom = 1180

func ready():
	$MarginContainer2.margin_left = -166
	$MarginContainer2.margin_top = 797
	$MarginContainer2.margin_right = -111
	$MarginContainer2.margin_bottom = 1570
	$MarginContainer2.visible = true
	
func _input(event):
	if event.is_action_pressed("escape"):
		ready()
	
func _on_Button_mouse_entered():
	$MarginContainer/Button.modulate.a8 = 225


func _on_Button_mouse_exited():
	$MarginContainer/Button.modulate.a8 = 255


func _on_Button_pressed():
	ready()
	$MarginContainer/Button.modulate.a8 = 100


func _on_Button2_pressed():
	notReady()


func _on_ButtonExit_pressed():
	save_game(player_vars)


func save_game(player_vars):
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	for i in range(0, 6):
		save_game.store_line(to_json(player_vars))
	save_game.close()



