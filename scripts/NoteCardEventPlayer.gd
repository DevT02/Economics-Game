extends CanvasLayer

export(String, FILE, "*.json") var data_file
export(ButtonGroup) var group

var data = []
var eventId = -1
var dialogue_active = false
var pressedButton = -1

var current_name = 'Mr CEO'
var current_company = 'tech'
var current_company_copied = 'tech'
var current_division = "none"
var current_events =  "events"
var from_events =  "fromevents"
var graphs = "graphs"
var current_choices =  "choices"
var current_outcomes =  "outcomes"
var current_outcome_profit = "profiteffects"
var current_outcome_image_effects =  "publicimgeffects"
var current_outcome_stakeholder =  "stakeholdereffects"
var allNullText = "Pick any option, you can't change this outcome!"
var emptyOptionText = "This option does nothing."
var difficultyFactor = 2

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
var hr_indexes = []
var marketing_indexes = []
var operations_indexes = []

var hq_indexes_general = []
var finance_indexes_general = []
var randd_indexes_general = []
var hr_indexes_general = []
var marketing_indexes_general = []
var operations_indexes_general = []

var known_numbers = []

onready var player_vars = get_node("/root/GlobalVars")

var indexes_dict = {
	"HQ": hq_indexes,
	"HR": hr_indexes,
	"Finance": finance_indexes,
	"Marketing": marketing_indexes,
	"R&D": randd_indexes,
	"Operations": operations_indexes,
	"HQ_general": hq_indexes_general,
	"R&D_general": randd_indexes_general,
	"HR_general": hr_indexes_general,
	"Marketing_general": marketing_indexes_general,
	"Finance_general": finance_indexes_general,
	"Operations_general": operations_indexes_general
}

func initialize_indexes(event_name, indexes_copy):
	var indexes = indexes_dict[event_name]
	indexes = [] # Clear the array and assign a new, empty one
	indexes.append_array(indexes_copy)

	
func init():
	pass
	
# on ready
func _ready():
	randomize()
	$MarginContainer/NinePatchRect.visible = false
	$MarginContainer2.visible = false
	get_node_or_null("../EffectsPopUp/Tween/MarginContainer").visible = false
	get_node_or_null("../EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").visible = false
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")
	data = load_data()
	profit = 75
	public_img = 75
	stakeholder = 75
	var fromevents = data[current_company][from_events]
	var from_gen_events = data["general"][from_events]
	
	for i in range(fromevents.size()):
		if fromevents[i] == "HQ":
			hq_indexes.append(i)
		elif fromevents[i] == "R&D":
			randd_indexes.append(i)
		elif fromevents[i] == "HR":
			hr_indexes.append(i)
		elif fromevents[i] == "Marketing":
			marketing_indexes.append(i)
		elif fromevents[i] == "Finance":
			finance_indexes.append(i)
		elif fromevents[i] == "Operations":
			operations_indexes.append(i)	

	
	for i in range(from_gen_events.size()):
		if from_gen_events[i] == "HQ":
			hq_indexes_general.append(i)
		elif from_gen_events[i] == "R&D":
			randd_indexes_general.append(i)
		elif from_gen_events[i] == "HR":
			hr_indexes_general.append(i)
		elif from_gen_events[i] == "Marketing":
			marketing_indexes_general.append(i)
		elif from_gen_events[i] == "Finance":
			finance_indexes_general.append(i)
		elif from_gen_events[i] == "Operations":
			operations_indexes_general.append(i)	
	#print(hq_indexes)
	initialize_indexes("HQ", hq_indexes)
	initialize_indexes("R&D", randd_indexes)
	initialize_indexes("HR", hr_indexes)
	initialize_indexes("Marketing", marketing_indexes)
	initialize_indexes("Finance", finance_indexes)
	initialize_indexes("Operations", operations_indexes)
	initialize_indexes("HQ_general", hq_indexes_general)
	initialize_indexes("R&D_general", randd_indexes_general)
	initialize_indexes("HR_general", hr_indexes_general)
	initialize_indexes("Marketing_general", marketing_indexes_general)
	initialize_indexes("Finance_general", finance_indexes_general)
	initialize_indexes("Operations_general", operations_indexes_general)
	
	if player_vars.profit != null:
		current_name = player_vars.name
		current_company = player_vars.company_selected
		updateLocalVars()
		updateDisplayEffects()
	
	# At the moment, there is like 1/2 the functionality for specific companies. Maybe later I'll take a look into it (once we add it)
	if player_vars.company_selected == "Random":
		var random_logo_indices = {0: 0,1: 2,2: 3,3: 4,4: 5, 5: 6}

		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var random_logo_index = rng.randi_range(0, 5)
		setFountainLogo(random_logo_indices[random_logo_index])
		updateWhenRandom(random_logo_indices[random_logo_index])
	else:
		var logo_indices = {"1": 2,"2": 0,"3": 3,"4": 4,"5": 5,"6": 6}
		setFountainLogo(logo_indices[player_vars.company_selected])

	current_name = player_vars.new_name
	
func setFountainLogo(index):
	get_node_or_null("../../TileMapLogos/").set_cell(-1, 18, index, false, false, false, Vector2(-1, 18))
	
	
# funcion to load data from json
func load_data():
	var file = File.new()
	if file.file_exists(data_file):
		file.open(data_file, file.READ)
		return parse_json(file.get_as_text())
		
# connect button press with on_ready
func button_pressed():
	if $MarginContainer/NinePatchRect.visible == true:
				
		if group.get_pressed_button() == group.get_buttons()[0]:
#			print("pressed one")
			updateEffects(button1Index)		
			fadeOut()
		elif group.get_pressed_button() == group.get_buttons()[1]:
#			print("pressed two")
			updateEffects(button2Index)
			fadeOut()
		elif group.get_pressed_button() == group.get_buttons()[2]:
#			print("pressed three")
			updateEffects(button3Index)
			fadeOut()
#		print(profit)
#		print(public_img)
#		print(stakeholder)

# when pressed (see interactions.gd)
func play(event):
	current_division = event
	if dialogue_active:
		return
	randomizeEvents()
	for button in group.get_buttons():
		button.disabled = false
		if button.text == emptyOptionText:
			button.disabled = true
	fadeIn()


func randomizeEvents():
	# generate random event to pick
#	if general_event_or_specific == 1:
#	current_company = ""
#	_nextEvent(get_random_index(current_division))
#	else:
	current_company_copied = current_company
	current_company = "general"
	#print("generalities of humanking")
	_nextEvent(get_random_index(current_division + "_general"))

func fadeIn():
	$MarginContainer/AnimationPlayer.play("fade_in")
#	print('fading in')
	dialogue_active = true
	$MarginContainer/NinePatchRect.visible = true

func fadeOut():
	$MarginContainer/AnimationPlayer.play("fade_out")
	get_tree().get_root().set_disable_input(true)
	yield(get_tree().create_timer(1), "timeout")
	get_tree().get_root().set_disable_input(false)
	$MarginContainer/NinePatchRect.visible = false
	dialogue_active = false

	
func _nextEvent(eventIndex):
#	print(eventIndex, " event index")
	$MarginContainer/NinePatchRect/ToLabel.text = current_name
	# fromLabels correspond with messageLabel (in size)
	#print(data[current_company][from_events])
	var graphNumber = data[current_company][graphs][eventIndex]
	if graphNumber != 0:
		group.get_buttons()[3].visible = true
		$MarginContainer2/NinePatchRect2/TextureRect.texture = load("res://assets//graphs//" + "graph" + str(graphNumber) + ".svg")
	else:
		group.get_buttons()[3].visible = false
	$MarginContainer/NinePatchRect/FromLabel.text = data[current_company][from_events][eventIndex] 
	$MarginContainer/NinePatchRect/MessageLabel.text = data[current_company][current_events][eventIndex]

	var button1 = (eventIndex) * 3 + (get_random_number_in_range(1, 3, known_numbers))
	var button2 = (eventIndex) * 3 + (get_random_number_in_range(1, 3, known_numbers))
	var button3 = (eventIndex) * 3 + (get_random_number_in_range(1, 3, known_numbers))
	button1Index = button1 - 1
	button2Index = button2 - 1
	button3Index = button3 - 1
#	print(button1Index, " 1 Index")
#	print(button2Index, " 2 Index")
#	print(button3Index, " 3 Index")
	# each event has corresonding 3 fromEvents, subtract 1 as we are using index, multiply by 3 as 3 per choice. 
	var data1 = data[current_company][current_choices][button1Index] 
	var data2 = data[current_company][current_choices][button2Index] 
	var data3 = data[current_company][current_choices][button3Index] 
#	print("data3 ", data3)
#	print("data2 ", data2)
#	print("data1 ", data1)
#	$NinePatchRect/Option1Button.text = data1 if data1 != null else ''
#	$NinePatchRect/Option2Button.text = data2 if data2 != null else ''
#	$NinePatchRect/Option3Button.text = data3 if data3 != null else ''
	var data1isNull = data1 == null
	var data2isNull = data2 == null
	var data3isNull = data3 == null
#	print("is data 1 null ", data1isNull)
#	print("is data 2 null ", data2isNull)
#	print("is data 3 null ", data3isNull)
	var notOnlyTwoOptions = true
	## ensure first two choices are filled to give optimal strategy
	if data1isNull && data2isNull && data3isNull:
		$MarginContainer/NinePatchRect/button1Label.text = allNullText
		$MarginContainer/NinePatchRect/button2Label.text = allNullText
		$MarginContainer/NinePatchRect/button3Label.text = allNullText
	elif data1isNull && not data2isNull:
#		print('X MARK X MARK data1 null')
		if not data3isNull:
			swapIndexes(1, 3)
			$MarginContainer/NinePatchRect/button1Label.text = data3
			$MarginContainer/NinePatchRect/button2Label.text = data2
			$MarginContainer/NinePatchRect/button3Label.text = emptyOptionText
			notOnlyTwoOptions = false
		else:
			swapIndexes(1, 2)
			$MarginContainer/NinePatchRect/button1Label.text = data2
		if data2isNull:
#			print("bro is bro")
			$MarginContainer/NinePatchRect/button2Label.text = emptyOptionText
	elif data2isNull && not data3isNull:
#		print('X MARK X MARK data1 null 2')
		# move 3rd option up in sorter!!
		if data1isNull:
#			print("go there")
			# 2 ARE NULL then
			swapIndexes(1, 3)
			$MarginContainer/NinePatchRect/button1Label.text = data3
			$MarginContainer/NinePatchRect/button2Label.text = emptyOptionText
			$MarginContainer/NinePatchRect/button3Label.text = emptyOptionText
		else:
#			print("got here !!!!!!")
			# data 2 is null, data 1 isnt null, data3 isnt null
			swapIndexes(2, 3)	
			$MarginContainer/NinePatchRect/button1Label.text = data1
			$MarginContainer/NinePatchRect/button2Label.text = data3
			$MarginContainer/NinePatchRect/button3Label.text = emptyOptionText
			notOnlyTwoOptions = false
			
		if not data2isNull:
			$MarginContainer/NinePatchRect/button3Label.text = emptyOptionText
			swapIndexes(1, 2)	
			$MarginContainer/NinePatchRect/button1Label.text = data3
			$MarginContainer/NinePatchRect/button2Label.text = emptyOptionText
			$MarginContainer/NinePatchRect/button3Label.text = emptyOptionText
				

	elif data3isNull:
#		print('bro is asjajsdksjljk')
		$MarginContainer/NinePatchRect/button3Label.text = emptyOptionText
		if not data2isNull:
			$MarginContainer/NinePatchRect/button2Label.text = data2
			$MarginContainer/NinePatchRect/button1Label.text = data1
			notOnlyTwoOptions = false
		else:
			$MarginContainer/NinePatchRect/button2Label.text = emptyOptionText
	else: 
		$MarginContainer/NinePatchRect/button1Label.text = data1 if data1 != null else ''
		$MarginContainer/NinePatchRect/button2Label.text = data2 if data2 != null else ''
		$MarginContainer/NinePatchRect/button3Label.text = data3 if data3 != null else ''
		
#	print(!notOnlyTwoOptions, " yo there r two options lol")
	
	if notOnlyTwoOptions:
		$MarginContainer/NinePatchRect/Option1Button.margin_bottom = 254
		$MarginContainer/NinePatchRect/Option2Button.margin_top = 261
		$MarginContainer/NinePatchRect/Option2Button.margin_bottom = 292
		$MarginContainer/NinePatchRect/Option3Button.visible = true
		$MarginContainer/NinePatchRect/button1Label.margin_bottom = 254
		$MarginContainer/NinePatchRect/button2Label.margin_top = 261
		$MarginContainer/NinePatchRect/button2Label.margin_bottom = 292
		$MarginContainer/NinePatchRect/button3Label.visible = true
	else:
		$MarginContainer/NinePatchRect/Option1Button.margin_bottom = 273
		$MarginContainer/NinePatchRect/Option2Button.margin_top = 282
		$MarginContainer/NinePatchRect/Option2Button.margin_bottom = 330
		$MarginContainer/NinePatchRect/Option3Button.visible = false
		$MarginContainer/NinePatchRect/button1Label.margin_bottom = 273
		$MarginContainer/NinePatchRect/button2Label.margin_top = 282
		$MarginContainer/NinePatchRect/button2Label.margin_bottom = 330
		$MarginContainer/NinePatchRect/button3Label.visible = false
	# final check! because we do not reset pick any option, if there are still some left, we need to account for it!

#	print("button3Index ", button3Index)
#	print("button2Index ", button2Index)
#	print("button1Index ", button1Index)
#	print('✔ passed checks')

	# the order of used_numbers3 will correspond to the option choices publically stored...
	
	
	if eventId >= len(data):
		print("uh oh.. data is too small!")
		dialogue_active = false
		$MarginContainer/NinePatchRect.visible = false 
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
		button2Index = button3Index
		button3Index = temp
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
	get_node_or_null("../EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").text = ""
	var text = data[current_company][current_outcomes][outcomeIndex]
#	print(text)
#	print(outcomeIndex)
	# stop everything if data is null
	if text != null:
		get_node("../EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").text = text
	else:
		updateNumericalEffects(outcomeIndex)
		return

	get_node_or_null("../EffectsPopUp/Tween/MarginContainer").visible = true
	get_node_or_null("../EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").visible = true

	get_node("../EffectsPopUp/AnimationPlayer").play("fade_in")
	get_node("../EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").visible_characters = 0
	var text_length = len(text)
	var text_reveal_speed = text_length * text_speed
	get_node("../EffectsPopUp/Tween/").interpolate_property(get_node("../EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label"), "visible_characters", 0, text_length, text_reveal_speed, Tween.TRANS_LINEAR)
	get_node("../EffectsPopUp/Tween/").start()

	var profit_percent_diff = data[current_company][current_outcome_profit][outcomeIndex]
	var public_img_diff = data[current_company][current_outcome_image_effects][outcomeIndex]
	var stakeholder_diff = data[current_company][current_outcome_stakeholder][outcomeIndex]
	updateNumericalEffects(outcomeIndex)
	var buttonEffect = 0
#	print(profit_percent_diff, " profit percent diff")
#	print(stakeholder_diff, " stakeholder_diff")
#	print(public_img_diff, " public_img_diff")

	
	var differences = (profit_percent_diff + public_img_diff + stakeholder_diff)
#	print(avgOfAllDiff)
	if differences < 0:
		buttonEffect = 1
	elif differences > 0 && differences < 0.0225:
		buttonEffect = 2
	elif differences >= 0.022:
		buttonEffect = 0
	else:
#		# idk?
		buttonEffect = 4
	
	# switch effect label
	match buttonEffect:
		0:
			# (GREEN)
			get_node("../EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").add_color_override("font_color", Color8(0, 255, 0, 255))
		1:
			# (RED) 
			get_node("../EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").add_color_override("font_color", "#FF7F7F")
		2:
			# (YELLOW)
			get_node("../EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").add_color_override("font_color", Color8(241, 255, 0, 255))
		4:
			# (cool effect maybe? or if == 0)
			get_node("../EffectsPopUp/Tween/MarginContainer/NinePatchRect/Label").add_color_override("font_color", "#00FFFF")

	current_company = current_company_copied
	pressedButton = outcomeIndex;
	# reset randomization (so we don't repeat numbers)

func updateNumericalEffects(outcomeIndex):
	profit *= 1 + data[current_company][current_outcome_profit][outcomeIndex] * difficultyFactor
	public_img *= 1 + data[current_company][current_outcome_image_effects][outcomeIndex] * difficultyFactor
	stakeholder *= 1 + data[current_company][current_outcome_stakeholder][outcomeIndex]	* difficultyFactor
	
	profit = min(profit, 100)
	public_img = min(public_img, 100)
	stakeholder = min(stakeholder, 100)
	
#	print(player_vars.profit, " profit")
#	print(profit, " profit")
	

#	for i in range(player_vars.profit  - profit):
#		get_node_or_null("../EffectsPopUp/Profit").value += profit
#	for i in range(player_vars.public_img - public_img):
#		get_node_or_null("../EffectsPopUp/PublicImage").value += profit
#	for i in range(player_vars.stakeholder - stakeholder):
#		get_node_or_null("../EffectsPopUp/Stakeholder").value += stakeholder
		
	updateGlobalVars()
#	print(profit)
#	print(public_img)
#	print(stakeholder)
	reupdateDisplayEffects(get_node_or_null("../EffectsPopUp/Profit"), profit, 1)
	reupdateDisplayEffects(get_node_or_null("../EffectsPopUp/PublicImage"), public_img,  1)
	reupdateDisplayEffects(get_node_or_null("../EffectsPopUp/Stakeholder"), stakeholder,  1)
	
	checkIfZero()
#	print(get_node_or_null("../EffectsPopUp/Stakeholder").value, "Stakeholder")
#	print(get_node_or_null("../EffectsPopUp/PublicImage").value, "PublicImage")
#	print(get_node_or_null("../EffectsPopUp/Profit").value, "Profit")
#	updateDisplayEffects()

func checkIfZero():
#	print(player_vars.profit, "< profit")
#	print(player_vars.stakeholder, "< stakeholder")
#	print(player_vars.public_img, "< public_img")
	if (player_vars.profit <= 6 || player_vars.public_img <= 6 || player_vars.stakeholder <= 6):
#		print('game over')
		get_node("../../Player").z_index = -3
		get_node("../../Player/CanvasLayer").layer = 3
		get_node("../../Player/CanvasLayer/GameOver").visible = true
		get_node("../../Player/CanvasLayer/GameOver").text = "Game Over!"
		get_node_or_null("../EffectsPopUp").visible = false
		
		get_node("../../Player").game_over()
		
		var restart_game_button = get_node("../../Player/CanvasLayer/RestartGame")
		restart_game_button.visible = true
		restart_game_button.accept_event()




func restart_game():
	# Resume the game
	print('yo trying')
	var tree = get_tree()
	var main_menu = "res://scenes/titlescreen.tscn"
	player_vars.game_over = true
	tree.change_scene(main_menu)
	


func updateGlobalVars():
	player_vars.profit = profit
	player_vars.public_img = public_img
	player_vars.stakeholder = stakeholder

func updateWhenRandom(random):
	player_vars.company_selected = str(random)

func updateLocalVars():
	profit = player_vars.profit
	public_img = player_vars.public_img
	stakeholder = player_vars.stakeholder

func reupdateDisplayEffects(texture_progress_node: Node, target_value: float, increment_or_decrement: float):
	var new_value = texture_progress_node.value
	var step_size = abs(increment_or_decrement)
	if target_value < texture_progress_node.value:
		step_size *= -1.0
	for i in range(texture_progress_node.value, target_value, step_size):
		new_value += step_size
		if (step_size > 0 and new_value > target_value) or (step_size < 0 and new_value < target_value):
			new_value = target_value
		texture_progress_node.value = new_value
		yield(get_tree().create_timer(0.1), "timeout") # Wait for a short time to update the progress visually
	texture_progress_node.value = target_value


func updateDisplayEffects():

	get_node_or_null("../EffectsPopUp/Profit").value = profit
	get_node_or_null("../EffectsPopUp/PublicImage").value = public_img
	get_node_or_null("../EffectsPopUp/Stakeholder").value = stakeholder


	
var last_index = -1
var used_indexes = {}
const MAX_ATTEMPTS = 100

func get_random_index(event_name):
	var indexes = indexes_dict.get(event_name, [])
	if indexes.size() == 0:
		return 0
	elif indexes.size() == 1:
		return indexes[0]
	else:
		for i in range(MAX_ATTEMPTS):
			var index = indexes[randi() % indexes.size()]
			if not used_indexes.has(index) and index != last_index:
				used_indexes[index] = true
				last_index = index
				if i % 10 == 0:
					used_indexes.clear()
				return index
		print("Could not find unused index after", MAX_ATTEMPTS, "attempts")
		return indexes[randi() % indexes.size()]


func get_random_number_in_range(start_range, end_range, known_numbers):
	var valid_numbers = [] 
	for i in range(start_range, end_range + 1):
		if not (i in known_numbers):
			valid_numbers.append(i)

	if valid_numbers.size() == 0:
		known_numbers.clear()
		valid_numbers = []
		for i in range(start_range, end_range + 1):
			valid_numbers.append(i)

	var index = randi() % valid_numbers.size()
	var random_number = valid_numbers[index]
	known_numbers.append(random_number)
	if valid_numbers.size() > 0:
		var find_index = valid_numbers.find(random_number)
		if find_index != -1:
			valid_numbers.remove(find_index)

	return random_number

func _input(event):
	if !dialogue_active:
		return

func _on_Option4Button_pressed():
	for button in group.get_buttons():
		button.disabled = true
	$MarginContainer/NinePatchRect.modulate.a8 = 80
	$MarginContainer2.visible = true


func _on_Button_pressed():
	for button in group.get_buttons():
		if (button.text != emptyOptionText):
			button.disabled = false
	$MarginContainer/NinePatchRect.modulate.a8 = 255
	$MarginContainer2.visible = false
