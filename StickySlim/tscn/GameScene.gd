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
		
	cells = [
		Vector2(17, 23),
		Vector2(17, 24),
		Vector2(17, 25),
		Vector2(17, 26),
#		Vector2(17, 23),
#		Vector2(18, 23),
#		Vector2(16, 22),
#		Vector2(18, 22)
		]
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
		l.text = "[" + str(int(cell.x)) + "," + str(int(cell.y)) + "]"
		add_child(l)
		
		bit_value = (bit_value*rot)%15

		var cur_id   = cell.x + cell.y     * rect.size.x
		var up_id    = cell.x + (cell.y-1) * rect.size.x
		var down_id  = cell.x + (cell.y+1) * rect.size.x
		var left_id  = cur_id - 1
		var right_id = cur_id + 1
		print("------bit_value:",bit_value)
		if bit_value & 1 == 1:
			star.connect_points(cur_id , up_id , false)
			print("up")
			print(cur_id , "-->" , up_id)
		if bit_value & 2 == 2:
			star.connect_points(cur_id , right_id , false)
			print("right")
			print(cur_id , "-->" , right_id)
		if bit_value & 4 == 4:
			star.connect_points(cur_id , down_id , false)
			print("down")
			print(cur_id , "-->" , down_id)
		if bit_value & 8 == 8:
			star.connect_points(cur_id , left_id , false)
			print("left")
			print(cur_id , "-->" , left_id)
			
#		Global.RoadMapBitArray[cell.y][cell.x] = bit_value
		
	Global.AStarPath = star
	Global.CurTMap = tile_map
	Global.RoadMap = road_map

func _process(delta):
	update()
	
func _draw():
	var rect = Rect2($Player.to_global($Player.body_rect.position) , $Player.body_rect.size)
	var down_position = rect.position + Vector2(rect.size.x / 2 , rect.size.y)
	var up_position = rect.position + Vector2(rect.size.x / 2 , 0)
	draw_rect(rect , Color(0,1,0,1) , true)
	draw_circle(up_position,5,Color(1,0,0,1))
	draw_circle(down_position,5,Color(1,0,0,1))
	draw_circle($Player.position,5,Color(1,0,1,1))