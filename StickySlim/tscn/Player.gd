extends "res://tscn/actor.gd"
var body_rect = Vector2(0,0)

func _ready():
	speed = 200
	body_rect = get_body_rect()
	
func _input(event):
	if event.is_action_pressed(ui_right):
		custom_input_envet(ui_right,true)
	if event.is_action_pressed(ui_left):
		custom_input_envet(ui_left,true)
	if event.is_action_pressed(ui_up):
		custom_input_envet(ui_up,true)
	if event.is_action_pressed(ui_down):
		custom_input_envet(ui_down,true)
		
	if event.is_action_released(ui_right):
		custom_input_envet(ui_right,false)
	if event.is_action_released(ui_left):
		custom_input_envet(ui_left,false)
	if event.is_action_released(ui_up):
		custom_input_envet(ui_up,false)
	if event.is_action_released(ui_down):
		custom_input_envet(ui_down,false)

func input_ctr():
	if is_action_pressed(ui_right):
		velocity.x = 1 * speed
	if is_action_pressed(ui_left):
		velocity.x = -1 * speed
	
	if is_action_released(ui_right) and velocity.x > 0:
		if is_action_pressed(ui_left):
			velocity.x = -1 * speed
		else:
			velocity.x = 0
	elif is_action_released(ui_left) and velocity.x < 0:
		if is_action_pressed(ui_right):
			velocity.x = 1 * speed
		else:
			velocity.x = 0

	if is_action_pressed(ui_up):
		velocity.y = -1 * speed
	if is_action_pressed(ui_down):
		velocity.y = 1 * speed
	
	if is_action_released(ui_up) and velocity.y > 0:
		if is_action_pressed(ui_down):
			velocity.y = 1 * speed
		else:
			velocity.y = 0
	elif is_action_released(ui_down) and velocity.x < 0:
		if is_action_pressed(ui_up):
			velocity.y = -1 * speed
		else:
			velocity.y = 0

func is_up_connected(p):
	var coord = Global.RoadMap.world_to_map(p)
	var c_id = coord.x + coord.y * Global.RoadMap.get_used_rect().size.x
	var n_id = coord.x + (coord.y - 1) * Global.RoadMap.get_used_rect().size.x
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
	
func _physics_process(delta):
	input_ctr()
	if is_climb_ladder():
		move_and_slide(velocity,Vector2(0,1))
	else:
		move_and_slide(Vector2(velocity.x,GRAVATY),Vector2(0,1))
	
func debug_path(path_arr):
		var debug_label = get_node("/root/GameScene/debug_label")
		for child in debug_label.get_children():
			child.queue_free()
			
		for coord in path_arr:
			var l = Label.new()
			l.rect_position = Vector2(coord.x,coord.y - 32)
			l.text = "."
			l.rect_scale = Vector2(4,4)
			l.modulate = Color(0,1,0)
			debug_label.add_child(l)
		print(path_arr)