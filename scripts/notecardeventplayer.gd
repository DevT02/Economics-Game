extends CanvasLayer

export(String, FILE, "*.json") var data_file

var data = []

func _ready():
	play()

func play():
	data = load_data()
	print(data)
	$NinePatchRect/ToLabel.text = data[0]['name']
	$NinePatchRect/MessageLabel.text = data[2]['tech_events'][0]
	
	$NinePatchRect/Option1Button.text = data[3]['tech_choices'][0]
	$NinePatchRect/Option2Button.text = data[3]['tech_choices'][1]
	$NinePatchRect/Option3Button.text = data[3]['tech_choices'][2]
	
	
func load_data():
	var file = File.new()
	if file.file_exists(data_file):
		file.open(data_file, file.READ)
		return parse_json(file.get_as_text())
