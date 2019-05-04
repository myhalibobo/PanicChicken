extends Node

var actor
var look_for_flag = false
var input_state_manage
var label_ai
var ground_wander
func _ready():
	
	actor = get_parent()
	ground_wander = actor.get_node("ground_wander")
	input_state_manage = actor.get_node("input_state")
	
#	var debug_label = actor.get_node("debug_label")
#	set_label_ai(debug_label.get_node("label_ai"))

var is_look_for_moving = false
var is_look_for_move_frame_end = false
var look_for_move_count = 0
var max_look_for_move_frame = 40

var is_idling = false
var is_idle_frame_end = false
var idle_count = 0
var max_idle_count = 40

func look_for_enemies_left_and_right():
	if not is_look_for_moving:
		is_look_for_moving = true
		negative_direction_move()
		is_look_for_move_frame_end = false
	
	if not is_look_for_move_frame_end:
		look_for_move_count +=1
		if look_for_move_count > max_look_for_move_frame:
			look_for_move_count = 0
			is_look_for_move_frame_end = true
		return

	if not is_idling:
		is_idling = true
		stop_move()
		is_idle_frame_end = false

	if not is_idle_frame_end:
		idle_count += 1
		if idle_count >= max_idle_count:
			idle_count = 0
			is_idle_frame_end = true
		return
	look_for_flag = false
	reset_look_for_enemies_left_and_right_data()

func reset_look_for_enemies_left_and_right_data():
	is_look_for_moving = false
	is_look_for_move_frame_end = false
	look_for_move_count = 0
	max_look_for_move_frame = 40

	is_idling = false
	is_idle_frame_end = false
	idle_count = 0
	max_idle_count = 40	

func negative_direction_move():
	if actor.direction == actor.RIGHT:
		move_left()
	if actor.direction == actor.LEFT:
		move_right()
		

func moving_to_target_with_deviation(target_postion,self_position,deviation):
	if target_postion.x > self_position.x and not is_arrive_right_border():
		if target_postion.x - self_position.x > deviation:
			move_right()
	elif target_postion.x < self_position.x and not is_arrive_left_border():
		if self_position.x - target_postion.x > deviation:
			move_left()
	else:
		stop_move()

func is_face_enemy(my_pos,e_pos,my_direction):
	if e_pos.x > my_pos.x and my_direction == actor.RIGHT:
		return true
	if e_pos.x < my_pos.x and my_direction == actor.LEFT:
		return true
	return false

func hover_move():
	if is_arrive_left_border():
		move_right()
	elif is_arrive_right_border():
		move_left()
	else:
		move_forward()

func stop_move():
	if not input_state_manage.is_action_released(actor.right):
		actor.send_key_input_event(actor.right , false)
	if not input_state_manage.is_action_released(actor.left):
		actor.send_key_input_event(actor.left , false)

func move_forward():
	if actor.direction == 1 and not input_state_manage.is_action_pressed(actor.right): 
		move_right()
	if actor.direction == -1 and not input_state_manage.is_action_pressed(actor.left):
		move_left()

func is_arrive_left_border():
	if actor.is_on_floor():
		if ground_wander.is_left_down_is_air():
			return true
		if ground_wander.is_left_collision_obstacles():
			return true
	return false

func is_arrive_right_border():
	if actor.is_on_floor():
		if ground_wander.is_rignt_down_is_air():
			return true
		if ground_wander.is_right_collision_obstacles():
			return true
	return false

func directly_change_to_attack():
	if actor.state_machine.get_cur_state().name != "attack":
		actor.attack()

func move_right():
	actor.send_key_input_event(actor.right,true)
	actor.send_key_input_event(actor.left,false)

func move_left():
	actor.send_key_input_event(actor.left,true)
	actor.send_key_input_event(actor.right,false)

func search_for_the_enemy(start_search_direction):
	pass

#-----------------debug-----------------#
export (bool) var is_label_ai = false
var lalel_ai
func set_label_ai(label):
	lalel_ai = label

func show_ai_info(info):
	if not is_label_ai:
		return
#	print("ai:" + info)
	lalel_ai.text = info