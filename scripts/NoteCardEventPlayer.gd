extends CanvasLayer

export(String, FILE, "*.json") var data_file
export(ButtonGroup) var group

var data = []
var eventId = -1
var dialogue_active = false
var pressedButton = -1

var used_numbers  = []
var current_company = "tech"
var current_events = current_company + "_events"
var from_events = current_company + "_fromevents"
var current_choices = current_company + "_choices"
var current_outcomes = current_company + "_outcomes"
var current_outcome_profit = current_company + "_profiteffects"
var current_outcome_image_effects = current_company + "_publicimgeffects"
var current_outcome_stakeholder = current_company + "_stakeholdereffects"
var profit = 0
var public_img = 0
var stakeholder = 0
## PUBLIC IMAGE, STAKHOLDER, PROFIT

#var rng = RandomNumberGenerator.new()

func _ready():
	$NinePatchRect.visible = false
	print(group.get_buttons())
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")

func button_pressed():
	print(group.get_pressed_button())
	if $NinePatchRect.visible == true:
		if group.get_pressed_button() == group.get_buttons()[0]:
			pressedButton = 0;
			fadeOut()
		elif group.get_pressed_button() == group.get_buttons()[1]:
			pressedButton = 1;
			fadeOut()
			pressedButton = 2;
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
	randomizeEvents()
	
func fadeOut():
	$AnimationPlayer.play("fade_out")
	get_tree().get_root().set_disable_input(true)
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().get_root().set_disable_input(false)
	$NinePatchRect.visible = false
	dialogue_active = false
	
	
func _nextEvent(eventId):
	$NinePatchRect/ToLabel.text = data[0]['name']
	$NinePatchRect/FromLabel.text = data[current_company][from_events][eventId]
	$NinePatchRect/MessageLabel.text = data[current_company][current_events][eventId]
	
	
	$NinePatchRect/Option1Button.text = data[current_company][current_choices][eventId * 3]
	$NinePatchRect/Option2Button.text = data[current_company][current_choices][eventId* 3 + 1]
	$NinePatchRect/Option3Button.text = data[current_company][current_choices][eventId* 3 + 2]
		
	
	if eventId >= len(data):
		print("uh oh.. data is too small!")
		dialogue_active = false
		$NinePatchRect.visible = false 
		return	
		
func randomizeEvents():

	match current_company:	
		"tech":	
			_nextEvent(generate_random_number(0, data[current_company][from_events].size() - 1, used_numbers))
		"fast_food":
			print("Y")
		"fashion":
			print("Z")

func erase():
	data[3][from_events].erase(eventId)
	data[3][from_events].erase(eventId)
	data[4][current_choices].erase(eventId)
	data[4][current_choices].erase(eventId+1)
	data[4][current_choices].erase(eventId+2)



func generate_random_number(range_start, range_end, known_numbers):
# Track the numbers that have been generated so far	
	# Create a list of all possible numbers in the range
	var possible_numbers = []
	for i in range(range_start, range_end + 1):
		var is_used = used_numbers.find(i) != -1
		var is_known = known_numbers.find(i) != -1
		if !is_used && !is_known:
			possible_numbers.append(i)
	print(possible_numbers)
	# If there are no possible numbers left, select a random known number
	if len(possible_numbers) == 0:
		for number in known_numbers:
			if used_numbers.find(number) == -1:
				return number
		# If all known numbers have already been used, just return a random number
		return range_start + randi() % (range_end - range_start + 1)
	
	# Otherwise, select a random possible number and return it
	var random_index = randi() % len(possible_numbers)
	used_numbers.append(possible_numbers[random_index])
	print(used_numbers)
	return possible_numbers[random_index]




func _input(event):
	if !dialogue_active:
		return

	
func load_data():
	var file = File.new()
	if file.file_exists(data_file):
		file.open(data_file, file.READ)
		return parse_json(file.get_as_text())
