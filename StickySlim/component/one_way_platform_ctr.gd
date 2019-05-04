extends Node

var actor
var input_state
var state_machine

onready var timer = $timer

func _ready():
	#必备条件
	actor = get_parent()
	input_state = actor.input_state
	state_machine = actor.state_machine
	#other
	timer.connect("timeout",self,"_on_timerout")
	timer.wait_time = 0.1

func _process(delta):
	if actor.input_state.is_action_pressed(actor.jump_down):
		var state_name = actor.state_machine.get_cur_state().name
		if state_name == "idle" or state_name == "walk" or state_name == "fall":
			timer.stop()
			timer.start()
			disEnable_collistion_with_oneWayPlatform()

func enable_collistion_with_oneWayPlatform():
	actor.collision_mask = actor.collision_mask | 128

func disEnable_collistion_with_oneWayPlatform():
	actor.collision_mask = actor.collision_mask & 0xfff7f

func _on_timerout():
	enable_collistion_with_oneWayPlatform()