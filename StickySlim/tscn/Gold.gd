extends Area2D

func _on_Gold_body_entered(body):
	
	if body.has_method("add_gold"):
		body.add_gold()
	
	queue_free()
