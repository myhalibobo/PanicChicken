tool
extends Node

var cell_size = Vector2(64,64)
var tile_map_size = Vector2(50,18)
enum Camp{people,monster}

var physical_player_layer = "player"
var collision_layers = {"terrain":1,"player":2,"monster":4,"playerAttack":8,"monsterAttack":16,"trap":32}

var left 	= "left_1"
var right 	= "right_1"
var up 		= "up_1"
var down 	= "down_1"
var jump 	= "jump_1"
var dash 	= "dash_1"
var attack 	= "attack_1"
var roll 	= "roll"
var jump_down = "jump_down"

