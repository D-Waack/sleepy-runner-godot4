extends Area2D

@export var type = 0

signal collected

func _on_body_entered(body):
	if body is Player:
		emit_signal("collected", type)
		queue_free()
