extends Area2D

func _ready():
	print("create gold:" , name)
	
func _on_Gold_body_entered(body):
	print("free gold:",name)
	queue_free()
	if body.has_method("add_gold"):
		body.add_gold()
