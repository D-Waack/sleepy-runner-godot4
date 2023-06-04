extends Area2D

@onready var collision_shape = $CollisionShape2D

signal destroyed

var broken = false

func _on_body_entered(body):
	if body is Arrow:
		emit_signal("destroyed")
		SoundManager.play_crystal_break()
		break_trigger(true)

func break_trigger(flag : bool):
	broken = flag
	set_visible(not flag)
	collision_shape.set_deferred("disabled", flag)
