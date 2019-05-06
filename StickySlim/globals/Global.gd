tool
extends Node

var AStarPath :AStar= null
var CurTMap :TileMap= null
var RoadMap :TileMap = null
var RoadMapBitArray = []

func get_tile_rect_by_worldPosition(tmap,wPostion):
	var pos = tmap.map_to_world(tmap.world_to_map(wPostion))
	var p =  Vector2(pos.x - tmap.cell_size.x / 2 , pos.y - tmap.cell_size.y / 2)
	return Rect2(p,tmap.cell_size)

func get_tile_rect_by_tmapCoord(tmap,coord):
	var pos = tmap.map_to_world(coord)
	var p =  Vector2(pos.x - tmap.cell_size.x / 2 , pos.y - tmap.cell_size.y / 2)
	return Rect2(p,tmap.cell_size)