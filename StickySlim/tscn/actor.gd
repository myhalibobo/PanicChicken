extends KinematicBody2D

var direction
var velocity = Vector2(0,0)
var speed = 100

enum {
	LEFT = -1,
	RIGHT = 1
}



var GRAVATY 	= 80
var ui_left 	= "ui_left"
var ui_right 	= "ui_right"
var ui_up 		= "ui_up"
var ui_down 	= "ui_down"

var inputArr = {
	ui_left  : false,
	ui_right : false,
	ui_up 	 : false,
	ui_down	 : false,
}

func _ready():
	direction = RIGHT

func _input(event):
	if event.is_action_pressed(ui_right):
		direction = RIGHT
		velocity.x = speed * direction
	if event.is_action_pressed(ui_left):
		direction = LEFT
		velocity.x = speed * direction
		
	if event.is_action_released(ui_right) and direction == RIGHT:
		if event.is_action_pressed(ui_left):
			direction = LEFT
			velocity.x = speed * direction
		else:
			velocity.x = 0
	elif event.is_action_released(ui_left) and direction == LEFT:
		if event.is_action_pressed(ui_right):
			direction = RIGHT
			velocity.x = speed * direction
		else:
			velocity.x = 0

func custom_input_envet(action , pressed):
#	if pressed and inputArr[action] == pressed:
#		_print_input_info("按下:" + action)
#	elif not pressed and inputArr[action] == pressed:
#		_print_input_info("释放：" + action)
	inputArr[action] = pressed
	
	
func _physics_process(delta):
	move_and_slide(Vector2(velocity.x,GRAVATY),Vector2(0,1))