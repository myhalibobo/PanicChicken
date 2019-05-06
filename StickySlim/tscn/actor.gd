extends KinematicBody2D

var direction = Vector2(0,0)
var velocity = Vector2(0,0)
var speed = 100
onready var body_shape = $BodyShape
var GRAVATY 	= 80
var ui_left 	= "ui_left"
var ui_right 	= "ui_right"
var ui_up 		= "ui_up"
var ui_down 	= "ui_down"

var _next_position

var inputArr = {
	ui_left  : false,
	ui_right : false,
	ui_up 	 : false,
	ui_down	 : false,
}

var path_arr = null

func _ready():
	print(name + " actor")
	pass

func control(delta):
	pass

func follow_path():
	if path_arr:
		var dir_vec = (_next_position - position)
		if dir_vec.length() < 5:
			if path_arr.size() == 0:
				path_arr = null
				return
			_next_position = path_arr[0]
			path_arr.remove(0)
			_next_position = Vector2(_next_position.x,_next_position.y)
			return
		var normal_vec = dir_vec.normalized()
		velocity = normal_vec * speed
		

func track():
	_next_position = position

func seek():
	pass

func get_body_rect():
	var radius = body_shape.shape.radius
	var height = body_shape.shape.height
	var position = body_shape.position - Vector2(radius , height)
	var size = Vector2(radius ,height) * scale * 2
	return Rect2(position,size)
	
func custom_input_envet(action , pressed):
	inputArr[action] = pressed
	
func is_action_pressed(action):
	return inputArr[action]

func is_action_released(action):
	return !inputArr[action]
	
#func _physics_process(delta):
#	follow_path()
#	control(delta)
#	move_and_slide(velocity,Vector2(0,1))
	