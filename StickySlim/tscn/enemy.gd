extends "res://tscn/actor.gd"


var track_body
onready var timer = $Timer
var is_dizzy = false
var debug_label = 0
func _ready():
	debug_label = Label.new()
	add_child(debug_label)
	
func wander():
	var coord = Global.RoadMap.world_to_map(position)
	if path_arr != null:
		return
		
	var c_id = coord.x + coord.y * Global.RoadMap.get_used_rect().size.x
	var up_id = coord.x + (coord.y - 1) * Global.RoadMap.get_used_rect().size.x
	var down_id = coord.x + (coord.y + 1) * Global.RoadMap.get_used_rect().size.x
	var left_id = coord.x + coord.y * Global.RoadMap.get_used_rect().size.x - 1
	var right_id = coord.x + coord.y * Global.RoadMap.get_used_rect().size.x + 1
	
	var cur_connects = Global.AStarPath.get_point_connections(c_id)
	cur_connects = Array(cur_connects)
	
	var select_arr = []
	if cur_direction == LEFT or cur_direction == RIGHT: #选择上下
		if array_has(cur_connects,up_id):
			select_arr.append(up_id)
		if array_has(cur_connects,down_id):
			select_arr.append(down_id)
			
	if cur_direction == UP or cur_direction == DOWN: #选择左右
		if array_has(cur_connects,left_id):
			select_arr.append(left_id)
		if array_has(cur_connects,right_id):
			select_arr.append(right_id)
	
	if select_arr.size() == 0: #直走
		if cur_direction == LEFT and array_has(cur_connects,left_id):
			select_arr.append(left_id)
		if cur_direction == RIGHT and array_has(cur_connects,right_id):
			select_arr.append(right_id)
		if cur_direction == UP and array_has(cur_connects,up_id):
			select_arr.append(up_id)
		if cur_direction == DOWN and array_has(cur_connects,down_id):
			select_arr.append(down_id)
			
	if select_arr.size() == 0:#反向走
		if cur_direction == LEFT and array_has(cur_connects,right_id):
			select_arr.append(right_id)
		if cur_direction == RIGHT and array_has(cur_connects,left_id):
			select_arr.append(left_id)
		if cur_direction == UP and array_has(cur_connects,down_id):
			select_arr.append(down_id)
		if cur_direction == DOWN and array_has(cur_connects,up_id):
			select_arr.append(up_id)
	
	var target
	if cur_direction == null:
		cur_connects.shuffle()
		target = cur_connects[0]
	else:
		select_arr.shuffle()
		target = select_arr[0]
		
#	if target != cur_direction:
#		debug_label.text = str(target)
		
	if target == up_id:
		cur_direction = UP
	elif target == down_id:
		cur_direction = DOWN
	elif target == left_id:
		cur_direction = LEFT
	elif target == right_id:
		cur_direction = RIGHT
		
	path_arr = []
	var p = Global.AStarPath.get_point_position(target)
	path_arr.append(Vector2(p.x,p.y))
		
	track()

func array_has(arr , v):
	for value in arr:
		if value == v:
			return true
	return false

func _on_Timer_timeout():
	var local_event = track_body.position
	var tar_coord = Global.RoadMap.world_to_map(local_event / Global.RoadMap.scale)
	var my_coord = Global.RoadMap.world_to_map(position / Global.RoadMap.scale)
	var rect = Global.RoadMap.get_used_rect()
	var my_id = my_coord.x + my_coord.y * rect.size.x
	var tar_id = tar_coord.x + tar_coord.y * rect.size.x
	if Global.AStarPath.has_point(my_id) and Global.AStarPath.has_point(tar_id):
		path_arr = Global.AStarPath.get_point_path(my_id,tar_id)
	else:
		path_arr == null
		return
		
	path_arr.remove(0)
	track()
	$Label.hide()

func _physics_process(delta):
	if not track_body or path_arr == null:
		wander()
		
	follow_path()
	update_direction()
	if is_dizzy:
		velocity.x = 0
	move_and_slide(velocity,Vector2(0,-1))

func take_damage():
	$Timer_dizzy.wait_time = 1.5
	$Timer_dizzy.start()
	is_dizzy = true

func _on_Area2D_body_entered(body):
	track_body = body
	
	timer.wait_time = 2
	timer.start()
	_on_Timer_timeout()
	if path_arr == null:
		$Label.show() 
	
func _on_Area2D_body_exited(body):
	track_body = null
	timer.stop()

func _on_Timer_dizzy_timeout():
	is_dizzy = false