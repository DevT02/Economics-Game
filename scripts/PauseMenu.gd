extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player_vars = get_node("/root/GlobalVars")
onready var new_stylebox_normal = $NinePatchRect/ButtonExit.get_stylebox("normal").duplicate()
# Called when the node enters the scene tree for the first time.
func _ready():
	$LargeText.visible = false
	$NinePatchRect.visible = false


	
func _input(event):
	if event.is_action_pressed("escape") && $NinePatchRect.visible == false:
		$NinePatchRect.visible = true
	elif event.is_action_pressed("escape") && $NinePatchRect.visible == true:
		$NinePatchRect.visible = false
func _on_Button_mouse_entered():
	print("entered")
	$Button.modulate.a8 = 180

func _on_Button_mouse_exited():
	$Button.modulate.a8 = 255

func _on_Button_pressed():
	$NinePatchRect.visible = true
	$Button.modulate.a8 = 50

func _on_Button2_pressed():
	$NinePatchRect.visible = false
	
func _on_ButtonExit_pressed():
	save_game()


func save():
	var save_dict = {
	"name" : player_vars.new_name,
		"company" : player_vars.company_selected,
		"profit" : player_vars.profit, 
		"stakeholder" : player_vars.stakeholder,
		"public_img" : player_vars.public_img,
	}
	for key in save_dict:
		if save_dict.has(key) and save_dict[key] == null:
			updateButton(new_stylebox_normal, "Play some more!!", "#FF0000", Color8(255, 255, 255, 255))
			return null
			
	return save_dict


func save_game():
	$LargeText.visible = true
	hide()
	$LargeText.text = "Saving Game..."
	var save_game = File.new()
	var stored_dict = save()

	print(stored_dict)
	if (stored_dict != null):
		save_game.open("user://savegame.dat", File.WRITE)
		save_game.store_var(stored_dict)
		print("saving game..")
		save_game.close()
		$LargeText.text = "Quitting Game..."
		yield(get_tree().create_timer(3), "timeout")
		get_tree().quit()
	else:
		$LargeText.visible = false
		show()
		yield(get_tree().create_timer(2), "timeout")
		updateButton(new_stylebox_normal, "Save and Exit", "#595959", Color8(255, 255, 255, 255))


func updateButton(style, text, hex, color):
	style.set_bg_color(Color(hex))
	$NinePatchRect/ButtonExit.set("custom_styles/normal", style)
	$NinePatchRect/ButtonExit.set("custom_styles/hover", style)
	$NinePatchRect/ButtonExit.set("custom_styles/pressed", style)
	$NinePatchRect/ButtonExit.text = text
	$NinePatchRect/ButtonExit.modulate = color


