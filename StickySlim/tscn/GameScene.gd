extends Node2D
onready var tile_map = $TileMap
onready var road_map = $road

func _ready():
	var path_call = []
	var star = AStar.new()
	var rect = road_map.get_used_rect()
	var cells = road_map.get_used_cells()

	for cell in cells:
		var p = road_map.map_to_world(Vector2(cell.x,cell.y)) + Vector2(32,32)
		star.add_point(cell.x + cell.y * rect.size.x , Vector3(p.x , p.y , 0))
		
#	cells = [
#		Vector2(16, 21),
#		Vector2(17, 21),
#		Vector2(18, 21),
#		Vector2(16, 23),
#		Vector2(17, 23),
#		Vector2(18, 23),
#		Vector2(16, 22),
#		Vector2(18, 22)
#		]
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
		l.text = str((bit_value*rot)%15)
#		l.text = "[" + str(int(l.rect_position.x)) + "," + str(int(l.rect_position.y)) + "]"
		add_child(l)
		
		bit_value = (bit_value*rot)%15

		var cur_id   = cell.x + cell.y     * rect.size.x
		var up_id    = cell.x + (cell.y-1) * rect.size.x
		var down_id  = cell.x + (cell.y+1) * rect.size.x
		var left_id  = cur_id - 1
		var right_id = cur_id + 1

		if bit_value & 1 == 1:
			print("up")
			star.connect_points(cur_id , up_id , false)
		if bit_value & 2 == 2:
			print("right")
			star.connect_points(cur_id , right_id , false)
		if bit_value & 4 == 4:
			print("down")
			star.connect_points(cur_id , down_id , false)
		if bit_value & 8 == 8:
			print("left")
			star.connect_points(cur_id , left_id , false)
		
		Global.RoadMapBitArray[cell.y][cell.x] = bit_value
		
	Global.AStarPath = star
	Global.CurTMap = tile_map
	Global.RoadMap = road_map