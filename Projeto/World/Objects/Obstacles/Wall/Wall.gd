extends StaticBody2D

class_name Wall

@onready var collision_shape = $CollisionShape2D

var destroyed = false

func destroy():
	hide_wall(true)

func hide_wall(flag: bool):
	destroyed = flag
	set_visible(not flag)
	collision_shape.set_deferred("disabled", flag)
