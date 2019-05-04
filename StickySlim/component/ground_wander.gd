extends Node2D

onready var left		= $RayCast2D_Left
onready var right		= $RayCast2D_Right
onready var left_down	= $RayCast2D_Leftdown
onready var right_down	= $RayCast2D_Rightdown

func _ready():
	pass

func is_left_down_is_air():
	if left_down and not left_down.is_colliding():
		return true
	else:
		return false
			
func is_left_collision_obstacles():
	if left and left.is_colliding():
		return true
	else:
		return false
		
func is_rignt_down_is_air():
	if right_down and not right_down.is_colliding():
		return true
	else:
		return false
		
func is_right_collision_obstacles():
	if right and right.is_colliding():
		return true
	else:
		return false
