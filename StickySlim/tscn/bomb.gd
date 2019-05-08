extends KinematicBody2D

var velocity = Vector2(0,0)
var GRAVATY  = 150
var speed    = 300

var note_player

func _ready():
	pass

func _physics_process(delta):
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.name == "TileMap":
			if collision.normal == Vector2(1,0) or collision.normal == Vector2(-1,0):
				velocity.x = 0
	
	move_and_slide(Vector2(velocity.x * speed , GRAVATY),Vector2(0,-1))

func _input(event):
	if event.is_action_pressed("ui_attack") and note_player:
		if note_player.cur_direction == note_player.LEFT:
 			shoot(1)
		if note_player.cur_direction == note_player.RIGHT:
			shoot(-1)
		set_process_input(false)

func shoot(direction):
	velocity.x = direction

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		note_player = body
		return
	if body.has_method("take_damage"):
		if position.x > body.position.x:
			body.take_damage(-1)
		else:
			body.take_damage(1)
	queue_free()

func _on_Timer_timeout():
	queue_free()

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		note_player = null