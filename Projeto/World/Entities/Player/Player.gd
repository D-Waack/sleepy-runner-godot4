extends CharacterBody2D

const SPEED = 210.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_direction = 1

signal mouse_in 

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if is_on_wall():
		facing_direction *= -1

	var direction = facing_direction
	velocity.x = direction * SPEED

	move_and_slide()


func _on_area_2d_mouse_entered():
	emit_signal("mouse_in", true)

func _on_area_2d_mouse_exited():
	emit_signal("mouse_in", false)
