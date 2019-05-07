extends "res://tscn/actor.gd"

export (PackedScene) var Bomb

var cur_bomb

func _ready():
	speed = 200
	GRAVATY = 150
	cur_direction = RIGHT
	
func _input(event):
	if event.is_action_pressed(ui_right):
		custom_input_envet(ui_right,true)
	if event.is_action_pressed(ui_left):
		custom_input_envet(ui_left,true)
	if event.is_action_pressed(ui_up):
		custom_input_envet(ui_up,true)
	if event.is_action_pressed(ui_down):
		custom_input_envet(ui_down,true)
	if event.is_action_pressed(ui_attack):
		shoot()
		custom_input_envet(ui_attack,true)
		
	if event.is_action_released(ui_right):
		custom_input_envet(ui_right,false)
	if event.is_action_released(ui_left):
		custom_input_envet(ui_left,false)
	if event.is_action_released(ui_up):
		custom_input_envet(ui_up,false)
	if event.is_action_released(ui_down):
		custom_input_envet(ui_down,false)
	if event.is_action_pressed(ui_attack):
		custom_input_envet(ui_attack,false)
		
func shoot():
	if not is_instance_valid(cur_bomb) or not cur_bomb:
		print(is_instance_valid(cur_bomb))
		var bombNode = get_node("/root/GameScene/BombNode")
		var bomb = Bomb.instance()
		bomb.position = position
		bombNode.add_child(bomb)
		cur_bomb = bomb
	else:
		if cur_direction == LEFT:
			cur_bomb.shoot(1)
		if cur_direction == RIGHT:
			cur_bomb.shoot(-1)
	
	
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
	elif is_action_released(ui_down) and velocity.y < 0:
		if is_action_pressed(ui_up):
			velocity.y = -1 * speed
		else:
			velocity.y = 0

func _physics_process(delta):
	input_ctr()
	update_direction()
	if is_climb_ladder():
		move_and_slide(velocity,Vector2(0,-1))
	else:
		move_and_slide(Vector2(velocity.x,GRAVATY),Vector2(0,-1))
		
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