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

	
#func backToScreen(text, company, items):
	
