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
var current_division = "none"
var current_events =  "events"
var from_events =  "fromevents"
var current_choices =  "choices"
var current_outcomes =  "outcomes"
var current_outcome_profit = "profiteffects"
var current_outcome_image_effects =  "publicimgeffects"
var current_outcome_stakeholder =  "stakeholdereffects"
var allNullText = "Pick any option, you can't change this outcome!"
var emptyOptionText = "This option does nothing."

var profit = 0
var public_img = 0
var stakeholder = 0
var text_speed = 0.02
var button1Index = null
var button2Index = null
var button3Index = null
## PUBLIC IMAGE, STAKHOLDER, PROFIT

#var rng = RandomNumberGenerator.new()
var hq_indexes = []
var finance_indexes = []
var randd_indexes = []
var handr_indexes = []
var marketing_indexes = []
var operations_indexes = []

# on ready
func _ready():
	$NinePatchRect.visible = false
	get_node("../EffectsPopUp/Tween/NinePatchRect/Label").visible = false
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")
	data = load_data()
	var fromevents = data[current_company][from_events]
	for i in range(fromevents.size()):
		if fromevents[i] == "HQ":
			hq_indexes.append(i)
		elif fromevents[i] == "R&D":
			randd_indexes.append(i)
		elif fromevents[i] == "HR":
			handr_indexes.append(i)
		elif fromevents[i] == "Marketing":
			marketing_indexes.append(i)
		elif fromevents[i] == "Finance":
			finance_indexes.append(i)
		elif fromevents[i] == "Operations":
			operations_indexes.append(i)	
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
#		print(profit)
#		print(public_img)
#		print(stakeholder)
# when pressed (see interactions.gd)
func play(event):
	current_division = event
	print('replaced division: ', event)
	if dialogue_active:
		return
	randomizeEvents()
	for button in group.get_buttons():
		button.disabled = false
		if button.text == emptyOptionText:
			button.disabled = true
	fadeIn()


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
	
	$NinePatchRect/ToLabel.text = data['name']
	# fromLabels correspond with messageLabel (in size)
   
	$NinePatchRect/FromLabel.text = data[current_company][from_events][eventIndex]
	$NinePatchRect/MessageLabel.text = data[current_company][current_events][eventIndex]
	
	var button1 = (eventIndex) * 3 + (generate_random_number(1, 3, used_numbers3, 3))
	var button2 = (eventIndex) * 3 + (generate_random_number(1, 3, used_numbers3, 3))
	var button3 = (eventIndex) * 3 + (generate_random_number(1, 3, used_numbers3, 3))
	button1Index = button1 - 1
	button2Index = button2 - 1
	button3Index = button3 - 1
	# each event has corresonding 3 fromEvents, subtract 1 as we are using index, multiply by 3 as 3 per choice. 
	var data1 = data[current_company][current_choices][button1Index] 
	var data2 = data[current_company][current_choices][button2Index] 
	var data3 = data[current_company][current_choices][button3Index] 

#	$NinePatchRect/Option1Button.text = data1 if data1 != null else ''
#	$NinePatchRect/Option2Button.text = data2 if data2 != null else ''
#	$NinePatchRect/Option3Button.text = data3 if data3 != null else ''
	var data1isNull = data1 == null
	var data2isNull = data2 == null
	var data3isNull = data3 == null
#	print("is data 1 null ", data1isNull)
#	print("is data 2 null ", data2isNull)
#	print("is data 3 null ", data3isNull)
	

	## ensure first two choices are filled to give optimal strategy
	if data1isNull && data2isNull && data3isNull:
#		print('nulldata')
		$NinePatchRect/Option1Button.text = allNullText
		$NinePatchRect/Option2Button.text = allNullText
		$NinePatchRect/Option3Button.text = allNullText
	elif data1isNull && not data2isNull:
#		print('X MARK X MARK data1 null')
		if not data3isNull:
			swapIndexes(1, 3)
			$NinePatchRect/Option1Button.text = data3
			$NinePatchRect/Option3Button.text = emptyOptionText
		else:
			swapIndexes(1, 2)
			$NinePatchRect/Option1Button.text = data2
	elif data3isNull && not data1isNull && not data2isNull:
		$NinePatchRect/Option3Button.text = emptyOptionText
	elif data2isNull && not data3isNull:
#		print('X MARK X MARK data1 null 2')
		# move 3rd option up in sorter!!
		if data1isNull:
			# 2 ARE NULL then
			swapIndexes(1, 3)
			$NinePatchRect/Option1Button.text = data3
			$NinePatchRect/Option2Button.text = emptyOptionText
			$NinePatchRect/Option3Button.text = emptyOptionText
			return
		else:
#			print("got here !!!!!!")
			# 1 ARE NULL then
			swapIndexes(2, 3)
			$NinePatchRect/Option1Button.text = data1
			$NinePatchRect/Option2Button.text = data3
			$NinePatchRect/Option3Button.text = emptyOptionText
			return
			
		swapIndexes(1, 2)	
#		print(data1, "<< data 1")
#		print(data2, "<< data 2")
#		print(data3, "<< data 3")
		$NinePatchRect/Option1Button.text = data3
		$NinePatchRect/Option2Button.text = emptyOptionText
		$NinePatchRect/Option3Button.text = emptyOptionText

	else: 
		$NinePatchRect/Option1Button.text = data1 if data1 != null else ''
		$NinePatchRect/Option2Button.text = data2 if data2 != null else ''
		$NinePatchRect/Option3Button.text = data3 if data3 != null else ''
	# final check! because we do not reset pick any option, if there are still some left, we need to account for it!

		
#	print('✔ passed checks')

	# the order of used_numbers3 will correspond to the option choices publically stored...
	
	
	if eventId >= len(data):
		print("uh oh.. data is too small!")
		dialogue_active = false
		$NinePatchRect.visible = false 
		return	
	
func swapIndexes(buttonpassedIndex1, buttonpassedIndex2):
	# NOT INDEXES, JUST BUTTON #
	var temp
	if buttonpassedIndex1 == 1 && buttonpassedIndex2 == 2 || buttonpassedIndex1 == 2 && buttonpassedIndex2 == 1:
		temp = button1Index
		button1Index = button2Index
		button2Index = temp
	# swap 2, 3
	elif buttonpassedIndex1 == 2 && buttonpassedIndex2 == 3 || buttonpassedIndex1 == 3 && buttonpassedIndex2 == 2:	
		temp = button2Index
		button3Index = button2Index
		button2Index = temp
	# allow reversible params
	elif buttonpassedIndex1 == 3 && buttonpassedIndex2 == 1 || buttonpassedIndex1 == 1 && buttonpassedIndex2 == 3:
		temp = button3Index
		button3Index = button1Index
		button1Index = temp
			
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

