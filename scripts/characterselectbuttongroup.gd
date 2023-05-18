extends Control
export(ButtonGroup) var group
onready var player_vars = get_node("/root/GlobalVars")

var button_map = {
	0: "whiteFemale",
	1: "brownMale",
	2: "blackFemale",
	3: "blackFemale2",
	4: "whiteMale2",
	5: "whiteMaleTopHat",
}

func _ready():
	$MarginContainer/AdvancedSelection.visible = false
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")

func button_pressed():
	if player_vars.character_selected != null:
		for button in group.get_buttons():
			button.modulate = Color8(255,255,255,255)

	var button = null
	for i in len(group.get_buttons()) - 1:
		button = group.get_buttons()[i]
		if group.get_pressed_button() == button:
			button.modulate = Color(0, 0, 0)
			player_vars.character_selected = button_map[i]
		else:
			button.modulate = Color(1, 1, 1)
			
	print(player_vars.character_selected, "<< character selected")
	
func _on_AdvancedSettingsButton_pressed():
	if player_vars.character_selected != null:
		self.modulate.a8 = 50
		$MarginContainer/TextureRect.visible = true
		$MarginContainer/AdvancedSelection.visible = true
	else:
		var new_stylebox_normal = $MarginContainer/TextureRect/AdvancedSettingsButton.get_stylebox("normal").duplicate()

		updateButton(new_stylebox_normal, "Pick a character to continue!", "#FF0000", Color8(255, 17, 17, 255))
		yield(get_tree().create_timer(1), "timeout")
		updateButton(new_stylebox_normal, "Continue!", "#44ffffff", Color8(255, 255, 255, 255))

func updateButton(style, text, hex, color):
	style.set_bg_color(Color(hex))
	$MarginContainer/TextureRect/AdvancedSettingsButton.set("custom_styles/normal", style)
	$MarginContainer/TextureRect/AdvancedSettingsButton.set("custom_styles/hover", style)
	$MarginContainer/TextureRect/AdvancedSettingsButton.set("custom_styles/pressed", style)
	$MarginContainer/TextureRect/AdvancedSettingsButton.text = text
	$MarginContainer/TextureRect/AdvancedSettingsButton.modulate = color

	
