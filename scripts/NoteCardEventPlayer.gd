extends CanvasLayer

export(String, FILE, "*.json") var data_file
export(ButtonGroup) var group

var data = []
var eventId = -1
var dialogue_active = false
var pressedButton = -1

var used_numbers  = []
var used_numbers2 = []
var used_numbers3 = []


var current_company = 'tech'
var current_events =  "events"
var from_events =  "fromevents"
var current_choices =  "choices"
var current_outcomes =  "outcomes"
var current_outcome_profit = "profiteffects"
var current_outcome_image_effects =  "publicimgeffects"
var current_outcome_stakeholder =  "stakeholdereffects"
var profit = 0
var public_img = 0
var stakeholder = 0
var option1effect = 0
var option2effect = 0
var option3effect = 0

## PUBLIC IMAGE, STAKHOLDER, PROFIT

#var rng = RandomNumberGenerator.new()

# on ready
func _ready():
	$NinePatchRect.visible = false
	print(group.get_buttons())
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")
	
# funcion to load data
func load_data():
	var file = File.new()
	if file.file_exists(data_file):
		file.open(data_file, file.READ)
		return parse_json(file.get_as_text())
		
# connect button press with on_ready
func button_pressed():
	print(group.get_pressed_button())
	if $NinePatchRect.visible == true:
		if group.get_pressed_button() == group.get_buttons()[0]:
			updateEffects(0)		
			fadeOut()
		elif group.get_pressed_button() == group.get_buttons()[1]:
			updateEffects(1)
			fadeOut()
		elif group.get_pressed_button() == group.get_buttons()[2]:
			updateEffects(2)
			fadeOut()
		print(profit)
		print(public_img)
		print(stakeholder)
		
		
# when pressed (see interactions.gd)
func play():
	if dialogue_active:
		return
	data = load_data()
	fadeIn()
	randomizeEvents()
	

func randomizeEvents():
	match current_company:	
		"tech":	
			_nextEvent(generate_random_number(0, data[current_company][current_events].size() - 1, used_numbers2, 2), generate_random_number(0, data[current_company][from_events].size() - 1, used_numbers, 0))
		"fast_food":
			print("Y")
		"fashion":
			print("Z")

func fadeIn():
	$AnimationPlayer.play("fade_in")
	print('fading in')
	dialogue_active = true
	$NinePatchRect.visible = true

func fadeOut():
	$AnimationPlayer.play("fade_out")
	get_tree().get_root().set_disable_input(true)
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().get_root().set_disable_input(false)
	$NinePatchRect.visible = false
	dialogue_active = false
	
# each event has corresonding 3 fromEvents	
func _nextEvent(numberofEvents, numberFromEvents):
	$NinePatchRect/ToLabel.text = data['name']
	$NinePatchRect/FromLabel.text = data[current_company][from_events][numberFromEvents]
	$NinePatchRect/MessageLabel.text = data[current_company][current_events][numberofEvents]
	
	$NinePatchRect/Option1Button.text = data[current_company][current_choices][(numberofEvents - 1) * 3 + (generate_random_number(0, 2, used_numbers3, 3))]
	$NinePatchRect/Option2Button.text = data[current_company][current_choices][(numberofEvents - 1) * 3 + (generate_random_number(0, 2, used_numbers3, 3))]
	$NinePatchRect/Option3Button.text = data[current_company][current_choices][(numberofEvents - 1) * 3 + (generate_random_number(0, 2, used_numbers3, 3))]
	# the order of used_numbers3 will correspond to the option choices publically stored...
	
	
	if eventId >= len(data):
		print("uh oh.. data is too small!")
		dialogue_active = false
		$NinePatchRect.visible = false 
		return	
		

func erase():
	data[3][from_events].erase(eventId)
	data[3][from_events].erase(eventId)
	data[4][current_choices].erase(eventId)
	data[4][current_choices].erase(eventId+1)
	data[4][current_choices].erase(eventId+2)

func updateEffects(buttonChoice):
	profit += data[current_company][current_outcome_profit][used_numbers3[buttonChoice]]	
	public_img += data[current_company][current_outcome_image_effects][used_numbers3[buttonChoice]]	
	stakeholder += data[current_company][current_outcome_stakeholder][used_numbers3[buttonChoice]]	
	pressedButton = buttonChoice;
	# reset randomization (so we don't repeat numbers)
	used_numbers3 = []

func generate_random_number(range_start, range_end, known_numbers, usedNumberIndex):
	# Track the numbers that have been generated so far	
	# Create a list of all possible numbers in the range
	var possible_numbers = []
	for i in range(range_start, range_end + 1):
#		var is_used = used_numbers.find(i) != -1
		var is_known = known_numbers.find(i) != -1
		if !is_known:
			possible_numbers.append(i)
	print(possible_numbers)
	# If there are no possible numbers left, select a random known number
	if len(possible_numbers) == 0:
		for number in known_numbers:
			if known_numbers.find(number) == -1:
				return number
		# If all known numbers have already been used, just return a random number
		return range_start + randi() % (range_end - range_start + 1)
	
	# Otherwise, select a random possible number and return it
	var random_index = randi() % len(possible_numbers)
	known_numbers.append(possible_numbers[random_index])
	# this is required, when passing a parameter it doesnt affect the global scope of the class (as we're creating a copy of the variable..) unfortunately this is the best solution.
	rememberUsedNumbers(known_numbers, usedNumberIndex)
	
	return possible_numbers[random_index]

func rememberUsedNumbers(known_numbers, usedNumberIndex):
	match usedNumberIndex:
		3:
			used_numbers3 = known_numbers
		2: 
			used_numbers2 = known_numbers
		1:
			used_numbers = known_numbers



func _input(event):
	if !dialogue_active:
		return

