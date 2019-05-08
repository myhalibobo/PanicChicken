extends Node2D

var draw_body

func _ready():
	pass
#	draw_body = get_parent().get_node("BombNode/enemy")

#func _process(delta):
#	update()
#
#func _draw():
#	var rect = Rect2(draw_body.to_global(draw_body.body_rect.position) , draw_body.body_rect.size)
#	var down_position = rect.position + Vector2(rect.size.x / 2 , rect.size.y)
#	var up_position = rect.position + Vector2(rect.size.x / 2 , 0)
#	draw_rect(rect , Color(0,1,0,0.2) , true)
#	draw_circle(up_position,5,Color(1,0,0,1))
#	draw_circle(down_position,5,Color(1,0,0,1))
#	draw_circle(draw_body.position,5,Color(1,0,1,1))