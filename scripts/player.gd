extends KinematicBody2D

var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2()

onready var animation = $Sprite/AnimationPlayer

func read_input():
	velocity = Vector2()
	if Input.is_action_pressed("up"):
		animation.play("walk_up")
		velocity.y -= 1
		direction = Vector2(0, -1)
	if Input.is_action_pressed("down"):
		animation.play("walk_down")
		velocity.y += 1
		direction = Vector2(0, 1)
	if Input.is_action_pressed("left"):
		animation.play("walk_left")
		velocity.x -= 1
		direction = Vector2(-1, 0)
	if Input.is_action_pressed("right"):
		animation.play("walk_right")
		velocity.x += 1
		direction = Vector2(1, 0)
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * 200)
	

func _physics_process(delta):
	read_input()




	
	
