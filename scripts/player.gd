extends KinematicBody2D

var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2()

onready var animation
onready var character = get_node("/root/GlobalVars").character_selected

onready var character_animations = {
	"brownMale": $AnimSprite/AnimatedSprite,
	"whiteFemale": $AnimSprite/AnimatedSprite2,
	"blackFemale": $AnimSprite/AnimatedSprite3,
	"blackFemale2": $AnimSprite/AnimatedSprite4,
	"whiteMale": $AnimSprite/AnimatedSprite5,
	"whiteMaleTopHat": $AnimSprite/AnimatedSprite6
}

func _ready():
	match_character()
	animation.play("walk_up")
	animation.stop()
			
func match_character():
	for i in len($AnimSprite.get_children()):
		$AnimSprite.get_child(i).visible = false

	print(character, " << fuck u ")
	match character:
		"whiteFemale":
			animation = character_animations["whiteFemale"]
			animation.visible = true
		"brownMale":
			animation = character_animations["whiteFemale"]
			animation.visible = true
		"blackFemale":
			animation = character_animations["blackFemale"]
			animation.visible = true
		"blackFemale2":
			animation = character_animations["blackFemale2"]
			animation.visible = true
		"whiteMale2":
			animation = character_animations["whiteMale2"]
			animation.visible = true
		"whiteMaleTopHat":
			animation = character_animations["whiteMaleTopHat"]
			animation.visible = true
func read_input():
	velocity = Vector2()
	if Input.is_action_pressed("up"):
		animation.play("walk_up")
		velocity.y -= 3
		direction = Vector2(0, -0.5)
	elif Input.is_action_pressed("down"):
		animation.play("walk_down")
		velocity.y += 3
		direction = Vector2(0, 0.5)
	elif Input.is_action_pressed("left"):
		animation.play("walk_left")
		velocity.x -= 3
		direction = Vector2(-0.5, 0)
	elif Input.is_action_pressed("right"):
		animation.play("walk_right")
		velocity.x += 3
		direction = Vector2(0.5, 0)
	else:
		animation.set_frame(0)
		animation.stop()
		

	velocity = move_and_slide(velocity * 200)
	

func _physics_process(delta):
	read_input()




	
	
