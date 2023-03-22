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
var text_speed = 0.02



## PUBLIC IMAGE, STAKHOLDER, PROFIT

#var rng = RandomNumberGenerator.new()

# on ready
func _ready():
	$NinePatchRect.visible = false
	get_node("../EffectsPopUp/Tween/NinePatchRect/Label").visible = false




	
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
			# generate random event to pick
			_nextEvent(generate_random_number(0, data[current_company][current_events].size() - 1, used_numbers2, 2))
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
	
func _nextEvent(numberofEvents):

	$NinePatchRect/ToLabel.text = data['name']
	# fromLabels correspond with messageLabel (in size)
	$NinePatchRect/FromLabel.text = data[current_company][from_events][numberofEvents]
	$NinePatchRect/MessageLabel.text = data[current_company][current_events][numberofEvents]
	
	print(numberofEvents)
	var button1 = (numberofEvents) * 3 + (generate_random_number(1, 3, used_numbers3, 3))
	var button2 = (numberofEvents) * 3 + (generate_random_number(1, 3, used_numbers3, 3))
	var button3 = (numberofEvents) * 3 + (generate_random_number(1, 3, used_numbers3, 3))

	# each event has corresonding 3 fromEvents, subtract 1 as we are using index, multiply by 3 as 3 per choice. 
	var data1 = data[current_company][current_choices][button1-1] 
	var data2 = data[current_company][current_choices][button2-1] 
	var data3 = data[current_company][current_choices][button3-1] 

	$NinePatchRect/Option1Button.text = data1 if data1 != null else ''
	$NinePatchRect/Option2Button.text = data2 if data2 != null else ''
	$NinePatchRect/Option3Button.text = data3 if data3 != null else ''
	
	
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
	# load text first then logic
	var text = data[current_company][current_outcomes][used_numbers3[buttonChoice]]
	
	get_node("../EffectsPopUp/Tween/NinePatchRect/Label").visible = true
	get_node("../EffectsPopUp/Tween/NinePatchRect/Label").visible_characters = 0
	get_node("../EffectsPopUp/Tween/NinePatchRect/Label").text = text
	var text_length = len(text)
	var text_reveal_speed = text_length * text_speed
	get_node("../EffectsPopUp/Tween/").interpolate_property(get_node("../EffectsPopUp/Tween/NinePatchRect/Label"), "visible_characters", 0, text_length, text_reveal_speed, Tween.TRANS_LINEAR)
	get_node("../EffectsPopUp/Tween/").start()
	
	var oldProfit = profit
	var oldImg = public_img
	var oldStakeholder = stakeholder
	profit += data[current_company][current_outcome_profit][used_numbers3[buttonChoice]]	
	public_img += data[current_company][current_outcome_image_effects][used_numbers3[buttonChoice]]	
	stakeholder += data[current_company][current_outcome_stakeholder][used_numbers3[buttonChoice]]	
	
	# based on differences, match a color to the text 0-0.5 is YELLOW (or okay) anything below 0 is RED (bad) anything above 0.5 is GREEN (great)
	var diffProfit = profit - oldProfit
	var diffImg = public_img - oldImg
	var diffStakeholder = stakeholder - oldStakeholder
	var buttonEffect = 0
	if diffStakeholder < 0 || diffImg < 0 || diffProfit < 0:
		buttonEffect = 1
	elif (0 < diffStakeholder && diffStakeholder <= 0.5) || (0 < diffImg && diffImg <= 0.5) || (0 < diffProfit && diffProfit <= 0.5):
		buttonEffect = 2
	elif (0 < diffStakeholder && diffStakeholder <= 1) || (0 < diffImg && diffImg <= 1) || (0 < diffProfit && diffProfit <= 1):
		buttonEffect = 0
	
	# switch effect label
	match buttonEffect:
		0:
			# (GREEN)
			get_node("../EffectsPopUp/Tween/NinePatchRect/Label").add_color_override("font_color", Color8(0, 255, 52, 255))
		1:
			# (RED) 
			get_node("../EffectsPopUp/Tween/NinePatchRect/Label").add_color_override("font_color", Color8(255, 0, 0, 255))
		2:
			# (YELLOW)
			get_node("../EffectsPopUp/Tween/NinePatchRect/Label").add_color_override("font_color", Color8(241, 255, 0, 255))



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

