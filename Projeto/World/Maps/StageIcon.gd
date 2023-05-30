extends Area2D

@export var stage_scene: PackedScene
@export var stage_index : int

@onready var shine_display = $StageStats/ShineDisplay
@onready var puzzle_display = $StageStats/PuzzleDisplay
@onready var rank = $StageStats/Rank

var mouse_in = false

const tile_size = 10
const tile_size_y = 8

func _input(event):
	if not mouse_in: return
	if event is InputEventMouseButton:
		if event.is_pressed():
			get_tree().change_scene_to_packed(stage_scene)

func _on_mouse_entered():
	mouse_in = true

func _on_mouse_exited():
	mouse_in = false

func set_stat(data: Array): # data tem shine_count, puzzle get e numero de mortes?
	if data[0] > 0:
		shine_display.set_visible(true)
		shine_display.set_size(Vector2(data[0] * tile_size, tile_size_y))
	if data[1]:
		puzzle_display.set_visible(true)
	
	print(calculate_rank(data[0], data[1]))
	
	rank.text = "[center][color=black]" + (calculate_rank(data[0], data[1]))

#[0,false,0],

func calculate_rank(shine_count, puzzle_get):
	print(shine_count)
	var rating := 0
	rating += shine_count
	if puzzle_get: rating += 1
	match rating:
		0: return 'C'
		1: return 'B'
		2: return 'A'
		3: return 'S'
		4: return 'S+'
		_: return 'C'
