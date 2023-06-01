extends Area2D

@export var type = 0

@onready var collision_shape = $CollisionShape2D

var been_collected

signal collected

func _on_body_entered(body):
	if been_collected: return
	if body is Player or body is Arrow:
		emit_signal("collected", type)
		collect(true)

func collect(flag : bool):
	been_collected = flag
	set_visible(not flag)
	collision_shape.set_deferred("disabled", flag)
