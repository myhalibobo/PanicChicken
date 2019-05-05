extends "res://tscn/actor.gd"

func _input(event):
	if event.is_action_pressed(ui_right):
		custom_input_envet(ui_right,true)
	if event.is_action_pressed(ui_left):
		custom_input_envet(ui_left,true)
	if event.is_action_pressed(ui_up):
		custom_input_envet(ui_up,true)
	if event.is_action_pressed(ui_down):
		custom_input_envet(ui_down,true)

func input_ctr():
	if is_action_pressed(ui_right):
		velocity.x = 1 * speed
	if is_action_pressed(ui_left):
		velocity.x = -1 * speed
	
	if is_action_released(ui_right) and velocity.x == 1:
		if is_action_pressed(ui_left):
			velocity.x = -1 * speed
		else:
			velocity.x = 0
	elif is_action_released(ui_left) and velocity.x == -1:
		if is_action_pressed(ui_right):
			velocity.x = 1 * speed
		else:
			velocity.x = 0

	if is_action_pressed(ui_up):
		velocity.y = -1 * speed
	if is_action_pressed(ui_down):
		velocity.y = 1 * speed
	
	if is_action_released(ui_up) and velocity.y == 1:
		if is_action_pressed(ui_down):
			velocity.y = 1 * speed
		else:
			velocity.y = 0
	elif is_action_released(ui_down) and velocity.x == -1:
		if is_action_pressed(ui_up):
			velocity.x = -1 * speed
		else:
			velocity.x = 0
	
func check_input_validity():
	var coord = Global.RoadMap.world_to_map(position)
	
	var bit_value = Global.RoadMapBitArray[coord.y][coord.x]
	if bit_value & 1 == 1 and is_action_pressed(ui_up):
		#可以上
		pass
	if bit_value & 2 == 2 and is_action_pressed(ui_right):
		#可以右移
		pass
	if bit_value & 4 == 4 and is_action_pressed(ui_down):
		#可以下移
		pass
	if bit_value & 8 == 8 and is_action_pressed(ui_left):
		#可以左移
		pass
	pass

func _physics_process(delta):
	input_ctr()
	move_and_slide(velocity,Vector2(0,1))
	

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