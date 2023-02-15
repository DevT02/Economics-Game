extends CanvasLayer

export(String, FILE, "*.json") var data_file
export(ButtonGroup) var group

var data = []
var eventId = 0
var dialogue_active = false

var current_company = "tech"
var from_department = current_company + "_from_events"
var current_events = current_company + "_events"
var current_choices = current_company + "_choices"
var current_outcomes = current_company + "_outcomes"

#var rng = RandomNumberGenerator.new()

func _ready():
	$NinePatchRect.visible = false
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")

func button_pressed():
	if $NinePatchRect.visible == true:
		if group.get_pressed_button() == group.get_buttons()[0]:
			fadeOut()
		elif group.get_pressed_button() == group.get_buttons()[1]:
			fadeOut()
		elif group.get_pressed_button() == group.get_buttons()[2]:
			fadeOut()
func play():
	if dialogue_active:
		return
	data = load_data()
	
	$AnimationPlayer.play("fade_in")
	print('fading in')
	dialogue_active = true
	$NinePatchRect.visible = true
	eventId=-1
	randomizeEvents()
	
func fadeOut():
	$AnimationPlayer.play("fade_out")
	get_tree().get_root().set_disable_input(true)
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().get_root().set_disable_input(false)
	$NinePatchRect.visible = false
	dialogue_active = false
	
	
func _nextEvent():
	eventId += 1
	print(eventId)
	$NinePatchRect/ToLabel.text = data[0]['name']
	$NinePatchRect/FromLabel.text = data[3][from_department][eventId]
	$NinePatchRect/MessageLabel.text = data[2][current_events][eventId]
	
	$NinePatchRect/Option1Button.text = data[4][current_choices][eventId]
	$NinePatchRect/Option2Button.text = data[4][current_choices][eventId+1]
	$NinePatchRect/Option3Button.text = data[4][current_choices][eventId+2]
	
	if eventId >= len(data):
		print("uh oh.. data is too small!")
		dialogue_active = false
		$NinePatchRect.visible = false 
		return	
		
func randomizeEvents():

	match current_company:	
		"tech":
			_nextEvent(	
			)
		"fast_food":
			print("Y")
		"fashion":
			print("Z")

func erase():
	data[3][from_department].erase(eventId)
	data[3][from_department].erase(eventId)
	data[4][current_choices].erase(eventId)
	data[4][current_choices].erase(eventId+1)
	data[4][current_choices].erase(eventId+2)



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
