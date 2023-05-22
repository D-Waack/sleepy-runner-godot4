extends Camera2D

var mouse_start_pos
var screen_start_position

var dragging = false

var can_drag = false

func _input(event):
	if not can_drag: 
		dragging = false
		return
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position

func follow_along(player):
	position = player.position
