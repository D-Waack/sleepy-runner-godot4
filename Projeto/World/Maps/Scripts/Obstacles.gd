extends Node2D

var wall = null

func _ready():
	for obstacle in get_children():
		if obstacle is Wall:
			wall = obstacle
			break

func destroy_wall():
	if wall != null:
		wall.destroy()

func unhide():
	for obstacle in get_children():
		if obstacle.has_method("hide_wall"):
			obstacle.hide_wall(false)
