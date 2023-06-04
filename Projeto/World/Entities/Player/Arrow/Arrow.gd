extends CharacterBody2D

class_name Arrow

const SPEED = 300.0

var direction = Vector2.ZERO

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	velocity = direction * SPEED
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		if collision.get_collider() is Enemy:
			collision.get_collider().kill()
		else:
			set_physics_process(false)

func _on_timer_timeout():
	queue_free()
