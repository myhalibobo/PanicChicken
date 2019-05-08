extends Node2D
onready var tile_map = $TileMap
onready var road_map = $road
var Gold = preload("res://tscn/Gold.tscn")
var random_ids = []

func _ready():
	randomize()
	var path_call = []
	var star = AStar.new()
	var rect = road_map.get_used_rect()
	var cells = road_map.get_used_cells()
	
	for cell in cells:
		var p = road_map.map_to_world(Vector2(cell.x,cell.y)) + Vector2(32,32)
		star.add_point(cell.x + cell.y * rect.size.x , Vector3(p.x , p.y , 0))

	for i in range(rect.size.y):
		var sub = []
		sub.resize(rect.size.x)
		Global.RoadMapBitArray.append(sub)
		
	for cell in cells:
		var id = road_map.get_cell(cell.x,cell.y)
		var name = road_map.tile_set.tile_get_name(id)
		var is_flip_x = road_map.is_cell_x_flipped(cell.x,cell.y)
		var is_flip_y = road_map.is_cell_y_flipped(cell.x,cell.y)
		var bit_value = int(name)
		var is_trans = road_map.is_cell_transposed(cell.x,cell.y)

		var rot = 1
		if is_flip_x and not is_flip_y and is_trans:
			rot = 2
		elif is_flip_x and is_flip_y and not is_trans:
			rot = 4
		elif not is_flip_x and is_flip_y and is_trans:
			rot = 8
			
		var l = Label.new()
		l.rect_position = road_map.map_to_world(Vector2(cell.x,cell.y)) + Vector2(30,30)
#		l.text = str((bit_value*rot)%15)
#		l.text = "[" + str(int(l.rect_position.x)) + "," + str(int(l.rect_position.y)) + "]"
#		l.text = "[" + str(int(cell.x)) + "," + str(int(cell.y)) + "]"
		add_child(l)
		
		bit_value = (bit_value*rot)%15

		var cur_id   = cell.x + cell.y     * rect.size.x
#		l.text = str(bit_value)

		var up_id    = cell.x + (cell.y-1) * rect.size.x
		var down_id  = cell.x + (cell.y+1) * rect.size.x
		var left_id  = cur_id - 1
		var right_id = cur_id + 1
		if bit_value & 1 == 1:
			star.connect_points(cur_id , up_id , false)
		if bit_value & 2 == 2:
			star.connect_points(cur_id , right_id , false)
		if bit_value & 4 == 4:
			star.connect_points(cur_id , down_id , false)
		if bit_value & 8 == 8:
			star.connect_points(cur_id , left_id , false)
			
		if bit_value == 10:
			random_ids.append(cur_id)
			
	Global.AStarPath = star
	Global.CurTMap = tile_map
	Global.RoadMap = road_map

func product_romdom_gold():
	var gold = Gold.instance()
	var items = get_node("Items")
	items.add_child(gold)
	random_ids.shuffle()
	var id = random_ids[0]
	var p = Global.AStarPath.get_point_position(id)
	gold.position = Vector2(p.x , p.y)

func update_progress_bar():
	pass # Replace with function body.
