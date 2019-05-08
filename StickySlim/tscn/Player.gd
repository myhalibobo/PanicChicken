extends "res://tscn/actor.gd"

export (PackedScene) var Bomb
signal product_gold
signal gold_num_changed
var cur_bomb
var own_gold_num = 0
var is_dead = false
var is_bomb_cd = false
func _ready():
	speed = 200
	GRAVATY = 150
	cur_direction = RIGHT
	yield(get_tree(),"idle_frame")
	emit_signal("product_gold")
	
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
#		if is_bomb_cd:
#			return
#		is_bomb_cd = true
		var bombNode = get_node("/root/GameScene/BombNode")
		var bomb = Bomb.instance()
		bomb.position = position
		bombNode.add_child(bomb)
		cur_bomb = bomb
#		$Timer_bomb_CD.wait_time = 5
#		$Timer_bomb_CD.start()
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

func update_direction():
	if velocity.x < 0:
		cur_direction = RIGHT
		$Sprite.flip_h = true
	if velocity.x > 0:
		cur_direction = LEFT
		$Sprite.flip_h = false

func add_gold():
	own_gold_num += 1
	emit_signal("product_gold")
	emit_signal("gold_num_changed", own_gold_num)

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

func _on_Area2D_body_entered(body):
	var parent = get_node("/root/GameScene")
	var die_tscn = preload("res://ui/die.tscn").instance()
	parent.add_child(die_tscn)
	
	$Area2D.set_deferred("monitoring",false)
	$Area2D.set_deferred("monitorable",false)
	set_physics_process(false)
	set_process_input(false)
	
func _on_Timer_bomb_CD_timeout():
	pass # Replace with function body.
