extends Area2D

signal destroyed

func _on_body_entered(body):
	if body is Arrow:
		emit_signal("destroyed")
		SoundManager.play_crystal_break()
		queue_free()
