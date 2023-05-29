extends Resource
class_name Stats

const SAVE_PATH := "user://data.tres"

@export var world1 : Array = [
	[0,false,0],
	[0,false,0],
	[0,false,0],
	[0,false,0],
	[0,false,0],
	[0,false,0],
	[0,false,0],
	[0,false,0],
	[0,false,0],
	[0,false,0]
	]

var worlds : Dictionary = {
	"1": world1
}

func update_stats(world_index: int, stage_index: int, new_stats: Array):
	var current_world = worlds[world_index]
	current_world[stage_index] = new_stats
