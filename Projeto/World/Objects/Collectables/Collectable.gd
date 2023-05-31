extends Area2D

@export var type = 0

var been_collected

signal collected

func _on_body_entered(body):
	if been_collected: return
	if body is Player or body is Arrow:
		been_collected = true
		emit_signal("collected", type)
		queue_free()
