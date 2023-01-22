extends CanvasLayer

export(String, FILE, "*.json") var data_file

var data = []
var eventId = 0;
#var rng = RandomNumberGenerator.new()

func _ready():
	$NinePatchRect.visible = false
#	rng.randomize()
#	randomize_event_number() # currently only supporting "tech" events



func play():
	data = load_data()
	print(data)
	$NinePatchRect.visible = true
	$NinePatchRect/ToLabel.text = data[0]['name']
	$NinePatchRect/FromLabel.text = data[3]['tech_from_events'][0]
	$NinePatchRect/MessageLabel.text = data[2]['tech_events'][0]
	
	$NinePatchRect/Option1Button.text = data[4]['tech_choices'][0]
	$NinePatchRect/Option2Button.text = data[4]['tech_choices'][1]
	$NinePatchRect/Option3Button.text = data[4]['tech_choices'][2]
	
	
#func randomize_event_number():
#	eventId = rng.randf_range(0, data[3]['tech_choices'] - 1)
	
func _input(event):
	if event.is_action_pressed("game_usage"):
		play()
	
func load_data():
	var file = File.new()
	if file.file_exists(data_file):
		file.open(data_file, file.READ)
		return parse_json(file.get_as_text())
