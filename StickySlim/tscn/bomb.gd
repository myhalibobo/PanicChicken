extends KinematicBody2D

var velocity = Vector2(0,0)
var GRAVATY  = 100
var speed    = 250

var note_player

func _ready():
	pass

func _physics_process(delta):
	move_and_slide(Vector2(velocity.x * speed , 0),Vector2(0,-1))

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
		body.take_damage()
	queue_free()

func _on_Timer_timeout():
	queue_free()

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		note_player = null