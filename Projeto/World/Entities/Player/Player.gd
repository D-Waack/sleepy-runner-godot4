extends CharacterBody2D

class_name Player

const SPEED = 210.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_direction = 1

signal dead

func _ready():
	set_physics_process(false)

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

func kill():
	set_physics_process(false)
	emit_signal("dead")

func reset_start():
	set_physics_process(true)
	facing_direction = 1
