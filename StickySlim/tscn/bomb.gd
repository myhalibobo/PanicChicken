extends KinematicBody2D

var velocity = Vector2(0,0)
var GRAVATY = 100
var speed = 250

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	move_and_slide(Vector2(velocity.x * speed,GRAVATY),Vector2(0,-1))

func shoot(direction):
	velocity.x *= direction

func _on_Area2D_body_entered(body):
	if body.name != "Player" and body.has_method("take_damage"):
		body.take_damage()
	queue_free()
