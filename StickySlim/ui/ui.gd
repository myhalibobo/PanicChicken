extends CanvasLayer

onready var progress_bar = $Container/ProgressBar


func _ready():
	pass # Replace with function body.

func update_gold_num(num):
	$Container/Label.text = "金币数量：" + str(num)

func update_progress_bar(time):
	progress_bar.value = 0
	$Tween.interpolate_property(progress_bar,"value",0,100,5,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	
