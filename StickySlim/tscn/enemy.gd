extends "res://tscn/actor.gd"

func _ready():
	pass # Replace with function body.

func control(delta):
	pass
#		var local_event = Global.RoadMap.make_input_local(event)
#		var tar_coord = Global.RoadMap.world_to_map(local_event.position / Global.RoadMap.scale)
#		var my_coord = Global.RoadMap.world_to_map(position / Global.RoadMap.scale)
#
#		print("my_coord:",my_coord," tar_coord:",tar_coord)
#		print(local_event.position)
#
#		var rect = Global.RoadMap.get_used_rect()
#		var my_id = my_coord.x + my_coord.y * rect.size.x
#		var tar_id = tar_coord.x + tar_coord.y * rect.size.x
#		path_arr = Global.AStarPath.get_point_path(my_id,tar_id)
#		path_arr.remove(0)
#		track()

