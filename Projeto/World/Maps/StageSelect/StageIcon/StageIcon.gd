extends Area2D

@export var stage_scene: PackedScene
@export var stage_index : int

@onready var shine_display = $StageStats/ShineDisplay
@onready var puzzle_display = $StageStats/PuzzleDisplay
@onready var rank = $StageStats/Rank

@onready var stage_number = $Label

var mouse_in = false

const tile_size = 10
const tile_size_y = 8

signal change_scene

func _ready():
	stage_number.text = str(stage_index + 1)

func _input(event):
	if not mouse_in: return
	if event is InputEventMouseButton:
		if event.is_pressed():
			emit_signal("change_scene", stage_index, stage_scene)

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
	
	rank.text = "[center][color=black]" + data[2]
