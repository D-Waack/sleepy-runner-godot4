extends Node

const SAVE_PATH = "user://data.json"

var stats : Resource = load("res://Managing/Persistent/Save1.tres")

func prepare_save():
	if save_exists():
		read_savegame()
		return
	write_savegame()

func save_exists():
	return FileAccess.file_exists(SAVE_PATH)

func read_savegame():
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		var error = FileAccess.get_open_error()
		printerr("Could not open file %s. Load is kill. Error code: %s" %
		[SAVE_PATH, error])
		return
	
	var content = JSON.parse_string(file.get_as_text())
	
	if content is Dictionary:
		stats.world1 = content["world1"]

func write_savegame():
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		var error = FileAccess.get_open_error()
		printerr("Could not open file %s. Save is kill. Error code: %s" %
		[SAVE_PATH, error])
		return
	
	var data = {
		"world1": stats.world1
	}
	
	var json_string := JSON.stringify(data)
	
	file.store_string(json_string)
	file.close()
