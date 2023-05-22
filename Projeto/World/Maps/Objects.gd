extends Node2D

var has_grabbed

signal fit_to_grid

func _ready():
	for object in get_children():
		object.connect("fit_to_grid", _on_Object_fit_to_grid)

func _process(_delta):
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		has_grabbed = false
		return
	for object in get_children():
		if object.grabbed:
			has_grabbed = true
			return
	has_grabbed = false

func block_grabbing(condition):
	for object in get_children():
		object.fixed = condition

func _on_Object_fit_to_grid(object):
	emit_signal("fit_to_grid", object)
