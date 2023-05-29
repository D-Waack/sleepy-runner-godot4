extends Area2D

@export var stage_scene: PackedScene

var mouse_in = false

func _input(event):
	if not mouse_in: return
	if event is InputEventMouseButton:
		if event.is_pressed():
			get_tree().change_scene_to_packed(stage_scene)

func _on_mouse_entered():
	mouse_in = true

func _on_mouse_exited():
	mouse_in = false
