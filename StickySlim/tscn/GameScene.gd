extends Node2D
onready var tile_map = $TileMap
onready var road_map = $road

func _ready():	
	var path_call = []
	var star = AStar.new()
	var rect = road_map.get_used_rect()
	var cells = road_map.get_used_cells()
#	cells = [Vector2(3,11),Vector2(4,11),Vector2(5,11),Vector2(6,11),Vector2(7,11)]
	for cell in cells:
		var p = road_map.map_to_world(Vector2(cell.x,cell.y)) + Vector2(32,32)
		star.add_point(cell.x + cell.y * rect.size.x , Vector3(p.x,p.y,0))
		
	for cell in cells:
		var id = road_map.get_cell(cell.x,cell.y)
		var name = road_map.tile_set.tile_get_name(id)
		var is_flip_x = road_map.is_cell_x_flipped(cell.x,cell.y)
		var is_flip_y = road_map.is_cell_y_flipped(cell.x,cell.y)
		var bit_value = int(name)
		var is_trans = road_map.is_cell_transposed(cell.x,cell.y)
#		print("is_flip_x:",is_flip_x," is_flip_y:",is_flip_y," is_trans:",is_trans)2
		
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
		add_child(l)
		
		var cur_id   = cell.x + cell.y     * rect.size.x
		var up_id    = cell.x + (cell.y-1) * rect.size.x
		var down_id  = cell.x + (cell.y+1) * rect.size.x
		var left_id  = cur_id - 1
		var right_id = cur_id + 1
		
		if rot & 1 == 1:
			star.connect_points(cur_id , up_id)
		if rot & 2 == 2:
			star.connect_points(cur_id , right_id)
		if rot & 4 == 4:
			star.connect_points(cur_id , down_id)
		if rot & 8 == 8:
			star.connect_points(cur_id , left_id)