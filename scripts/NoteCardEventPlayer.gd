extends CanvasLayer

export(String, FILE, "*.json") var data_file
export(ButtonGroup) var group

var data = []
var eventId = -1
var dialogue_active = false
var pressedButton = -1


var current_company = 'tech'
var current_division = "none"
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
var button1Index = null
var button2Index = null
var button3Index = null
## PUBLIC IMAGE, STAKHOLDER, PROFIT

#var rng = RandomNumberGenerator.new()


var known_numbers = []
var previous_numbers = []

var indexes_dict = {
	"HQ": hq_indexes,
	"HR": hr_indexes,
	"Finance": finance_indexes,
	"Marketing": marketing_indexes,
	"R&D": randd_indexes,
	"Operations": operations_indexes
}

func initialize_indexes(event_name, indexes_copy):
	var indexes = indexes_dict[event_name]
	indexes = [] # Clear the array and assign a new, empty one
	indexes.append_array(indexes_copy)

	
# on ready
func _ready():
	$NinePatchRect.visible = false
	$NinePatchRect2.visible = false
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
			updateEffects(button1Index)		
			fadeOut()
		elif group.get_pressed_button() == group.get_buttons()[1]:
			updateEffects(button2Index)
			fadeOut()
		elif group.get_pressed_button() == group.get_buttons()[2]:
			updateEffects(button3Index)
			fadeOut()
		print(profit)
		print(public_img)
		print(stakeholder)

# when pressed (see interactions.gd)
func play(event):
	current_division = event
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
	
func _nextEvent(eventIndex):
	print(eventIndex, " event index")
	$NinePatchRect/ToLabel.text = data['name']
	# fromLabels correspond with messageLabel (in size)

	$NinePatchRect/FromLabel.text = current_division
	$NinePatchRect/MessageLabel.text = data[current_company][current_events][numberofEvents]
	
	var button1 = (numberofEvents) * 3 + (generate_random_number(1, 3, used_numbers3, 3))
	var button2 = (numberofEvents) * 3 + (generate_random_number(1, 3, used_numbers3, 3))
	var button3 = (numberofEvents) * 3 + (generate_random_number(1, 3, used_numbers3, 3))
	button1Index = button1 - 1
	button2Index = button2 - 1
	button3Index = button3 - 1
	# each event has corresonding 3 fromEvents, subtract 1 as we are using index, multiply by 3 as 3 per choice. 
	var data1 = data[current_company][current_choices][button1Index] 
	var data2 = data[current_company][current_choices][button2Index] 
	var data3 = data[current_company][current_choices][button3Index] 

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

func updateEffects(outcomeIndex):
	# see in this function, we dont have to worry about null values as they will be set to 0
	# load text first then logic
	var text = data[current_company][current_outcomes][outcomeIndex]
	print(text)
	# stop everything if data is null
	if text != null:
		get_node("../EffectsPopUp/Tween/NinePatchRect/Label").text = text
	else:
		updateNumericalEffects(outcomeIndex)
		used_numbers3 = []
		return
	
	get_node("../EffectsPopUp/Tween/NinePatchRect/Label").visible = true
	get_node("../EffectsPopUp/Tween/NinePatchRect/Label").visible_characters = 0
	var text_length = len(text)
	var text_reveal_speed = text_length * text_speed
	get_node("../EffectsPopUp/Tween/").interpolate_property(get_node("../EffectsPopUp/Tween/NinePatchRect/Label"), "visible_characters", 0, text_length, text_reveal_speed, Tween.TRANS_LINEAR)
	get_node("../EffectsPopUp/Tween/").start()
	
	var oldProfit = profit
	var oldImg = public_img
	var oldStakeholder = stakeholder
	updateNumericalEffects(outcomeIndex)
	
	# based on numerical differences, match a color to the text 0-0.5 is YELLOW (or okay) anything below 0 is RED (bad) anything above 0.5 is GREEN (great)
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
	else:
		# idk?
		buttonEffect = 4
		
	
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
		4:
			# (cool effect maybe? or if == 0)
			get_node("../EffectsPopUp/Tween/NinePatchRect/Label").add_color_override("font_color", Color8(0, 0, 255, 255))


	pressedButton = outcomeIndex;
	# reset randomization (so we don't repeat numbers)
	used_numbers3 = []

func updateNumericalEffects(outcomeIndex):
	profit += data[current_company][current_outcome_profit][outcomeIndex]	
	public_img += data[current_company][current_outcome_image_effects][outcomeIndex]	
	stakeholder += data[current_company][current_outcome_stakeholder][outcomeIndex]	



func get_random_index(event_name):
	var indexes = indexes_dict[event_name]
	if indexes.size() == 0:
		return 0
	elif indexes.size() == 1:
		return indexes[0]
	else:
		var index = randi() % indexes.size()
		var indexes_copy = indexes.duplicate()
		indexes_copy.remove(index)
		return indexes[index] if indexes[index] != null else get_random_index(event_name)

func get_random_number_in_range(start_range, end_range, known_numbers):
	var valid_numbers = []
	for i in range(start_range, end_range + 1):
		if not (i in known_numbers):
			valid_numbers.append(i)

	if valid_numbers.size() == 0:
		known_numbers.clear()
		for i in range(start_range, end_range + 1):
			valid_numbers.append(i)

	var index = randi() % valid_numbers.size()
	var random_number = valid_numbers[index]
	known_numbers.append(random_number)
	valid_numbers.remove(random_number)
	return random_number

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

