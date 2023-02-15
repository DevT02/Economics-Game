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
#	randomize_event_number() # currently only supporting "tech" events

func button_pressed():
	if $NinePatchRect.visible == true:
		if group.get_pressed_button() == group.get_buttons()[0]:
			$AnimationPlayer.play("fade_out")
			yield(get_tree().create_timer(1), "timeout")
			$NinePatchRect.visible = false
		if group.get_pressed_button() == group.get_buttons()[1]:
			$AnimationPlayer.play("fade_out")
			yield(get_tree().create_timer(1), "timeout")
			$NinePatchRect.visible = false
		if group.get_pressed_button() == group.get_buttons()[2]:
			$AnmationPlayer.play("fade_out")
			yield(get_tree().create_timer(1), "timeout")
			$NinePatchRect.visible = false
func play():
	if dialogue_active:
		return
	data = load_data()
	
	$AnimationPlayer.play("fade_in")
	dialogue_active = true
	$NinePatchRect.visible = true
	eventId=-1
	_nextEvent()
	
#func randomize_event_number():
#	eventId = rng.randf_range(0, data[3]['tech_choices'] - 1)
	
func _nextEvent():
	eventId += 1
	$NinePatchRect/ToLabel.text = data[eventId]['name']
	$NinePatchRect/FromLabel.text = data[3][from_department][eventId]
	$NinePatchRect/MessageLabel.text = data[2][current_events][eventId]
	
	$NinePatchRect/Option1Button.text = data[4][current_choices][eventId]
	$NinePatchRect/Option2Button.text = data[4][current_choices][eventId+1]
	$NinePatchRect/Option3Button.text = data[4][current_choices][eventId+2]
	
	if eventId >= len(data):
		dialogue_active = false
		$NinePatchRect.visible = false 
		return	
		
func randomizeEvents(company):

	match company:	
		"tech":
			print("X")
		"fast_food":
			print("Y")
		"fashion":
			print("Z")




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
