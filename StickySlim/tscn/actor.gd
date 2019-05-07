extends KinematicBody2D

var direction = Vector2(0,0)
var velocity = Vector2(0,0)
var speed = 100
var GRAVATY = 100
var _next_position
var body_rect = Vector2(0,0)
onready var body_shape = $BodyShape
var cur_direction = null

var ui_left 	= "ui_left"
var ui_right 	= "ui_right"
var ui_up 		= "ui_up"
var ui_down 	= "ui_down"
var ui_attack   = "ui_attack"

var inputArr = {
	ui_left  : false,
	ui_right : false,
	ui_up 	 : false,
	ui_down	 : false,
	ui_attack: false
}

enum{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var path_arr = null

func _ready():
	_next_position = position
	body_rect = get_body_rect()
	cur_direction = LEFT + randi() % 1

func follow_path():
	if path_arr != null:
		var dir_vec = (_next_position - position)
		if dir_vec.length() < 5:
			if path_arr.size() == 0:
				path_arr = null
				velocity = Vector2(0,0)
				return
			_next_position = path_arr[0]
			path_arr.remove(0)
			_next_position = Vector2(_next_position.x,_next_position.y + 20)
			return
		var normal_vec = dir_vec.normalized()
		velocity = normal_vec * speed
		
func track():
	_next_position = position

func is_up_connected(p):
	var coord = Global.RoadMap.world_to_map(p)
	var c_id = coord.x + coord.y * Global.RoadMap.get_used_rect().size.x
	var n_id = coord.x + (coord.y - 1) * Global.RoadMap.get_used_rect().size.x
	if not Global.AStarPath.has_point(c_id):
		return false
	var arr = Global.AStarPath.get_point_connections(c_id)
	for i in range(arr.size()):
		if arr[i] == n_id:
			return true
	return false

func is_climb_ladder():
	var is_climb_ladder = false
	var rect = body_rect
	var g_position = to_global(rect.position)
	var down_position = g_position + Vector2(rect.size.x / 2 , rect.size.y)
	var up_position = g_position + Vector2(rect.size.x / 2 , 0)
#	print("o" , Global.RoadMap.world_to_map(position) , " up:" , Global.RoadMap.world_to_map(up_position) , " down" , Global.RoadMap.world_to_map(down_position))
	if is_up_connected(up_position) or is_up_connected(down_position):
		return true
	return false

func update_direction():
	if velocity.x < 0:
		cur_direction = RIGHT
		$Sprite.flip_h = true
	if velocity.x > 0:
		cur_direction = LEFT
		$Sprite.flip_h = false
		
func get_body_rect():
	var radius = body_shape.shape.radius
	var height = body_shape.shape.height / 2 + radius
	var position = body_shape.position - Vector2(radius , height)
	var size = Vector2(radius ,height) * scale * 2
	return Rect2(position,size)
	
func custom_input_envet(action , pressed):
	inputArr[action] = pressed
	
func is_action_pressed(action):
	return inputArr[action]

func is_action_released(action):
	return !inputArr[action]
	