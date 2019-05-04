extends "../platform_actor.gd"

export (String) var left = "left_1"
export (String) var right = "right_1"
export (String) var up = "up_1"
export (String) var down = "down_1"
export (String) var jump = "jump_1"
export (String) var dash = "dash_1"
export (String) var attack = "attack_1"


export (Resource) var aiControl

var isFindPath = false
var pathFinder
var pathArr
var tileMap
var nextCoord
var preAutoKey = []
var labelRoot
var jumpTimer
var debug_roleGoPath = []
var into_area_bodys = []

onready var enemy_tree = $enemy_tree
onready var bt_bb = $bt_bb
onready var animationBody = $animationBody
onready var area2D_atk1 = $Area2D_atk1
onready var area2D_atk2 = $Area2D_atk2
onready var area2D_atk3 = $Area2D_atk3

var atk_poly_right_1
var atk_poly_right_2
var atk_poly_right_3

var atk_poly_left_1
var atk_poly_left_2
var atk_poly_left_3

func handle_input():
	pass 
    
func _ready():
	pathFinder = get_node("/root/PathFinderFast")
	tileMap = self.get_parent().get_node("TileMap")

	jumpTimer = Timer.new()
	jumpTimer.one_shot = true
	jumpTimer.connect("timeout",self,"_on_jump_timer_timeout") 
	add_child(jumpTimer)
		
	$animationBody.connect("frame_changed",self,"_on_animationBody_frame_changed")
	
	_init_attack_polygon()


func _init_attack_polygon():
	atk_poly_left_1 = PoolVector2Array()
	atk_poly_left_2 = PoolVector2Array()
	atk_poly_left_3 = PoolVector2Array()
	
	atk_poly_right_1 = area2D_atk1.get_node("CollisionPolygon2D").polygon
	for point in atk_poly_right_1:
		var vec_p = Vector2(point.x * -1,point.y)
		atk_poly_left_1.push_back(vec_p)
	
	atk_poly_right_2 = area2D_atk2.get_node("CollisionPolygon2D").polygon
	for point in atk_poly_right_2:
		var vec_p = Vector2(point.x * -1,point.y)
		atk_poly_left_2.push_back(vec_p)

	atk_poly_right_3 = area2D_atk3.get_node("CollisionPolygon2D").polygon
	for point in atk_poly_right_3:
		var vec_p = Vector2(point.x * -1,point.y)
		atk_poly_left_3.push_back(vec_p)



#func _process(delta):
#	if enemy_tree and bt_bb:
#		enemy_tree.tick(self,bt_bb)
		
#func _input(event):
#	if event is InputEventMouseButton and event.is_pressed() and is_role:
#		var start = tileMap.world_to_map(position)
#		start.x = floor(start.x / tileMap.scale.x)
#		start.y = floor(start.y / tileMap.scale.y)
#
#		var pos1 = tileMap.get_global_transform_with_canvas()[2]
#		event.position.x = event.position.x - pos1.x
#		event.position.y = event.position.y - pos1.y
#
#		var end = tileMap.world_to_map(event.position)
#		end.x = floor(end.x / tileMap.scale.x)
#		end.y = floor(end.y / tileMap.scale.y)
#
#		print("start:",start," end:",end)
#		pathArr = pathFinder.FindPath(start,end,1,1,2)
#		if pathArr:
#			if labelRoot:
#				labelRoot.queue_free()
#			labelRoot = Node2D.new()
#			get_parent().add_child(labelRoot)
#
#			for i in range(pathArr.size()):
#				var p = pathArr[i]
#				var pos = tileMap.map_to_world(pathArr[i])
#				var label = Label.new()
#				labelRoot.add_child(label)
#				label.text = str(i)
#				label.rect_position = Vector2(pos.x * tileMap.scale.x + 32 , pos.y * tileMap.scale.y + 32)
#
#		if pathArr:
#			pathArr.append(start)
#			var newArr = pathArr.duplicate(true)
#			newArr.invert()
#			print(newArr)
#			nextCoord = pathArr.pop_back()
#			print("pop:",nextCoord)
#			debug_roleGoPath = []
			
func _process(delta):
	if pathArr != null:
		debug_rolePath()
		var roleCoord = _get_position_tile_map_coord()
		if is_reach_target(roleCoord,nextCoord):
			if pathArr.size() == 0:
				pathArr = null
				sendKeyInputEvent(left,false)
				sendKeyInputEvent(right,false)
				return
			nextCoord  = pathArr.pop_back()
			print("pop:",nextCoord)
		if input_state_manage.is_action_pressed(jump) and is_on_floor():
			jumpTimer.stop()
			_on_jump_timer_timeout()
		if roleCoord.x > nextCoord.x and not input_state_manage.is_action_pressed(left):
			sendKeyInputEvent(left,true)
			sendKeyInputEvent(right,false)
		if roleCoord.x < nextCoord.x and not input_state_manage.is_action_pressed(right):
			sendKeyInputEvent(right,true)
			sendKeyInputEvent(left,false)
		if roleCoord.y > nextCoord.y and not input_state_manage.is_action_pressed(jump):
			sendKeyInputEvent(jump,true)
			jumpTimer.wait_time = 0.7
			jumpTimer.start() 
		if is_need_small_jump(roleCoord) and not input_state_manage.is_action_pressed(jump):
			sendKeyInputEvent(jump,true)
			jumpTimer.wait_time = 0.1
			jumpTimer.start()

func getBodySize():
	return $shape.shape.extents * scale

func _getPath_Finder_Start_Pos():
	var start = tileMap.world_to_map(position)
	start.x = floor(start.x / tileMap.scale.x)
	start.y = floor(start.y / tileMap.scale.y)

func _get_position_tile_map_coord():
	var bodySize = getBodySize()
	
	var roleCoord = tileMap.world_to_map(position)
	roleCoord.x = floor(roleCoord.x / tileMap.scale.x)
	roleCoord.y = floor(roleCoord.y / tileMap.scale.y)
	return roleCoord

func sendKeyInputEvent(key,pressed):
	input_state_manage.custom_input_envet(key,pressed)


func is_need_small_jump(cur):
	if tileMap.get_cell(cur.x,cur.y + 1) == -1 or tileMap.get_cell(cur.x + direction , cur.y + 1) == -1:
		return
	var id = tileMap.get_cell(cur.x,cur.y+1)
	var curSize = tileMap.tile_set.tile_get_shape(id,0).extents
	id = tileMap.get_cell(cur.x+direction,cur.y+1)
	var nextSize = tileMap.tile_set.tile_get_shape(id,0).extents
	if nextSize.y > curSize.y:
		return true
	else:
		return false

func debug_rolePath():
	var insertFlag = true
	var r = _get_position_tile_map_coord()
	for v in debug_roleGoPath:
		if v.x == r.x and v.y == r.y:
			 insertFlag = false
	if insertFlag:
		debug_roleGoPath.append(r)
#		print("role go path:",r)

func is_reach_target(roleCoord,nextCoord):
	if roleCoord.x == nextCoord.x and roleCoord.y == nextCoord.y:
		return true
	if roleCoord.x == nextCoord.x and roleCoord.y < nextCoord.y and not is_on_floor():
		for i in range(nextCoord.y - roleCoord.y):
			if tileMap.get_cell(nextCoord.x ,nextCoord.y + i) != -1:
				return false
		sendKeyInputEvent(left,false)
		sendKeyInputEvent(right,false)


func _on_jump_timer_timeout():
	sendKeyInputEvent(jump,false)
	pass

func setFindPath(flag):
	isFindPath = flag

func _on_Area2D_atk_body_entered(body):
	body.reduction_blood()

func _on_animationBody_frame_changed():
	if get_state().name == "attack":
		area2D_atk1.monitoring = false
		area2D_atk2.monitoring = false
		area2D_atk3.monitoring = false
		if animationBody.frame == 2:
			if direction == 1:
				area2D_atk1.get_node("CollisionPolygon2D").polygon = atk_poly_right_1
			else:
				area2D_atk1.get_node("CollisionPolygon2D").polygon = atk_poly_left_1
			area2D_atk1.monitoring = true
		elif animationBody.frame == 8:
			if direction == 1:
				area2D_atk2.get_node("CollisionPolygon2D").polygon = atk_poly_right_2
			else:
				area2D_atk2.get_node("CollisionPolygon2D").polygon = atk_poly_left_2
			area2D_atk2.monitoring = true
		elif animationBody.frame == 14:
			if direction == 1:
				area2D_atk3.get_node("CollisionPolygon2D").polygon = atk_poly_right_3
			else:
				area2D_atk3.get_node("CollisionPolygon2D").polygon = atk_poly_left_3
			area2D_atk3.monitoring = true



