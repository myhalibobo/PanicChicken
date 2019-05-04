extends Node

var data_map = {}
var file_list = [
	"actors_config.json"
]
func _ready():
	init_data()
	
func init_data():
	var path = "res://config"
	var file_list = dir_contents_list(path)
	print("load config file...")
	for file in file_list:
		var map_key = file.split("_")[0]
		var config_path = path + "/" + file
		print(config_path)
		data_map[map_key] = parse_json_file(config_path)


func parse_json_file(config_path):
	var data_file = File.new()
	var result = data_file.open(config_path, File.READ)
	if result != OK:
		print("file load fail error_code:" , result)
		return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return
	var data = data_parse.result
	return data

func get_config_data_by_name_and_uniq_id(map_key,uniq_id):
	return data_map[map_key][uniq_id]
	
func dir_contents_list(path):
	var file_list = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if not dir.current_is_dir():
				file_list.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return file_list