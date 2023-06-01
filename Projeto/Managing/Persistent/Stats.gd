extends Resource
class_name Stats

const SAVE_PATH := "user://data.tres"

var default_world : Array = [
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C']
]

@export var world1 : Array = [
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C'],
	[0,false,'C']
	]

var worlds : Dictionary = {
	"1": world1
}

func update_stats(world_index: int, stage_index: int, new_stats: Array):
	var current_world = worlds[world_index]
	current_world[stage_index] = new_stats

func reset_world():
	world1 = default_world
