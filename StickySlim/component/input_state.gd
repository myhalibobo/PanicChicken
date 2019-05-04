extends Node
class_name InputState
var inputArr = {
	Global.up   	 : false,
	Global.down 	 : false,
	Global.left 	 : false,
	Global.right	 : false,
	Global.jump 	 : false,
	Global.dash 	 : false,
	Global.attack 	 : false,
	Global.roll   	 : false,
	Global.jump_down : false,
}
var enable_jump_key = true
var state_machine
var actor
func _ready():
	actor = get_parent()
	state_machine = actor.get_node("state_machine")

func _unhandled_input(event):
	if not actor.is_role:
		return
	#-------------------pass----------------------#
	if event.is_action_pressed(Global.up):
		custom_input_envet(Global.up,true)
	elif event.is_action_pressed(Global.down):
		custom_input_envet(Global.down,true)
	elif event.is_action_pressed(Global.left):
		custom_input_envet(Global.left,true)
	elif event.is_action_pressed(Global.right):
		custom_input_envet(Global.right,true)
	elif event.is_action_pressed(Global.jump):
		custom_input_envet(Global.jump,true)
		enable_jump_key = false
	elif event.is_action_pressed(Global.dash):
		custom_input_envet(Global.dash,true)
	elif event.is_action_pressed(Global.attack):
		custom_input_envet(Global.attack,true)
	elif event.is_action_pressed(Global.roll):
		custom_input_envet(Global.roll,true)
	elif event.is_action_pressed(Global.jump_down):
		custom_input_envet(Global.jump_down,true)
	#-------------------release----------------------#
	if event.is_action_released(Global.up):
		custom_input_envet(Global.up,false)
	elif event.is_action_released(Global.down):
		custom_input_envet(Global.down,false)
	elif event.is_action_released(Global.left):
		custom_input_envet(Global.left,false)
	elif event.is_action_released(Global.right):
		custom_input_envet(Global.right,false)
	elif event.is_action_released(Global.jump):
		enable_jump_key = true
		custom_input_envet(Global.jump,false)
	elif event.is_action_released(Global.dash):
		custom_input_envet(Global.dash,false)
	elif event.is_action_released(Global.attack):
		custom_input_envet(Global.attack,false)
	elif event.is_action_released(Global.roll):
		custom_input_envet(Global.roll,false)
	elif event.is_action_released(Global.jump_down):
		custom_input_envet(Global.jump_down,false)

func is_action_pressed(action):
	return inputArr[action]

func is_action_released(action):
	return !inputArr[action]

func custom_input_envet(action , pressed):
	if pressed and inputArr[action] == pressed:
		_print_input_info("按下:" + action)
	elif not pressed and inputArr[action] == pressed:
		_print_input_info("释放：" + action)
	inputArr[action] = pressed
	state_machine.input_process()

#-----------------debug------------------#
export (bool) var is_open_input = false
func _print_input_info(info):
	if not is_open_input:
		return
	print("input:" + info)