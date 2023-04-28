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

var character_selected = null
var company_selected = null
var profit = null
var stakeholder = null
var public_img = null


func save():
	var save_dict = {
		"name" : player_vars.new_name,
		"company" : player_vars.company_selected,
		"profit" : player_vars.profit, # Vector2 is not supported by JSON
		"stakeholder" : player_vars.stakeholder,
		"public_img" : player_vars.public_img,
	}
	for key in save_dict:
		if save_dict.has(key) and save_dict[key] == null:
			print("Null value detected.")
			$MarginContainer2/NinePatchRect/ButtonExit.text = "Play some more"
			var new_stylebox_normal = $MarginContainer2/NinePatchRect/ButtonExit.get_stylebox("normal").duplicate()
			updateButton(new_stylebox_normal, "Play some more!!", "#FF0000", Color8(255, 255, 255, 255))
			yield(get_tree().create_timer(1), "timeout")
			updateButton(new_stylebox_normal, "Save and Exit", "#595959", Color8(255, 255, 255, 255))
			return null
	return save_dict

func save_game(player_vars):
	
	var save_game = File.new()
	var stored_dict = save()
	if (stored_dict != null):
		save_game.open("user://savegame.save", File.WRITE)

		save_game.store_string(var2str(stored_dict))
		print("saving game..")
		save_game.close()

func updateButton(style, text, hex, color):
	style.set_bg_color(Color(hex))
	$MarginContainer2/NinePatchRect/ButtonExit.set("custom_styles/normal", style)
	$MarginContainer2/NinePatchRect/ButtonExit.set("custom_styles/hover", style)
	$MarginContainer2/NinePatchRect/ButtonExit.set("custom_styles/pressed", style)
	$MarginContainer2/NinePatchRect/ButtonExit.text = text
	$MarginContainer2/NinePatchRect/ButtonExit.modulate = color


