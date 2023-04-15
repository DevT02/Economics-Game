extends Control
export(ButtonGroup) var group
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player_vars = get_node("/root/GlobalVars")
# Called when the node enters the scene tree for the first time.

func _ready():
	$MarginContainer/AdvancedSelection.visible = false
	print(group.get_buttons())
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")

func button_pressed():
	if player_vars.character_selected != null:
		for button in group.get_buttons():
			button.modulate = Color8(255,255,255,255)
	
	if group.get_pressed_button() == group.get_buttons()[0]:
		group.get_buttons()[0].modulate = Color(0,0,0)
		player_vars.character_selected = "brownMale"
	elif group.get_pressed_button() == group.get_buttons()[1]:
		group.get_buttons()[1].modulate = Color(0,0,0)
		player_vars.character_selected = "whiteFemale"

		

func backToScreen(name, company):
	for i in group.get_buttons():
		i.disabled = false


func _on_AdvancedSettingsButton_pressed():
	if player_vars.character_selected != null:
		self.modulate.a8 = 50
		$MarginContainer/TextureRect.visible = true
		$MarginContainer/AdvancedSelection.visible = true
	else:
		var new_stylebox_normal = $MarginContainer/TextureRect/AdvancedSettingsButton.get_stylebox("normal").duplicate()
		
		updateButton(new_stylebox_normal, "Pick a character to continue!", "##FF0000", Color8(255, 17, 17, 255))
		yield(get_tree().create_timer(0.6), "timeout")
		updateButton(new_stylebox_normal, "Continue!", "#44ffffff", Color8(255, 255, 255, 255))

func updateButton(style, text, hex, color):
	style.set_bg_color(Color(hex))
	$MarginContainer/TextureRect/AdvancedSettingsButton.set("custom_styles/normal", style)
	$MarginContainer/TextureRect/AdvancedSettingsButton.set("custom_styles/hover", style)
	$MarginContainer/TextureRect/AdvancedSettingsButton.set("custom_styles/pressed", style)
	$MarginContainer/TextureRect/AdvancedSettingsButton.text = text
	$MarginContainer/TextureRect/AdvancedSettingsButton.modulate = color
#func backToScreen(text, company, items):
	
