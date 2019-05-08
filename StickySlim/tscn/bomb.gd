extends KinematicBody2D

var velocity = Vector2(0,0)
var GRAVATY = 100
var speed = 250
var is_going = false
func _ready():
	pass

func _physics_process(delta):
	move_and_slide(Vector2(velocity.x * speed , 0),Vector2(0,-1))

func shoot(direction):
	if is_going:
		return
	is_going = true
	velocity.x = direction

func _on_Area2D_body_entered(body):
	if body.name != "Player" and body.has_method("take_damage"):
		body.take_damage()
	queue_free()

func _on_Timer_timeout():
	queue_free()
