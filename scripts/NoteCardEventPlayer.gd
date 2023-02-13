extends CanvasLayer

export(String, FILE, "*.json") var data_file

var data = []
var eventId = 0
var dialogue_active = false
#var rng = RandomNumberGenerator.new()

func _ready():
	$NinePatchRect.visible = false
#	rng.randomize()
#	randomize_event_number() # currently only supporting "tech" events



func play():
	if dialogue_active:
		return
	data = load_data()
		
	dialogue_active = true
	$NinePatchRect.visible = true
	$NinePatchRect/ToLabel.text = data[eventId]['name']
	$NinePatchRect/FromLabel.text = data[3]['tech_from_events'][eventId]
	$NinePatchRect/MessageLabel.text = data[2]['tech_events'][eventId]
	
	$NinePatchRect/Option1Button.text = data[4]['tech_choices'][eventId]
	$NinePatchRect/Option2Button.text = data[4]['tech_choices'][eventId+1]
	$NinePatchRect/Option3Button.text = data[4]['tech_choices'][eventId+2]
	
#func randomize_event_number():
#	eventId = rng.randf_range(0, data[3]['tech_choices'] - 1)
	
func _nextEvent():
	eventId += 1
	$NinePatchRect/ToLabel.text = data[eventId]['name']
	$NinePatchRect/FromLabel.text = data[3]['tech_from_events'][eventId]
	$NinePatchRect/MessageLabel.text = data[2]['tech_events'][eventId]
	
	$NinePatchRect/Option1Button.text = data[4]['tech_choices'][eventId]
	$NinePatchRect/Option2Button.text = data[4]['tech_choices'][eventId+1]
	$NinePatchRect/Option3Button.text = data[4]['tech_choices'][eventId+2]
	
	if eventId >= len(data):
		dialogue_active = false
		$NinePatchRect.visible = false 
		return	

func _input(event):
	if not dialogue_active:
		return
	
	if event.is_action_pressed("game_usage"):
		_nextEvent()

	
func load_data():
	var file = File.new()
	if file.file_exists(data_file):
		file.open(data_file, file.READ)
		return parse_json(file.get_as_text())
