extends CanvasLayer

func _ready():
	pass # Replace with function body.

func update_gold_num(num):
	$Container/Label.text = "金币数量：" + str(num)
