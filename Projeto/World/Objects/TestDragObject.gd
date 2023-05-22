extends StaticBody2D

@onready var sprite = $Sprite2D

@onready var grab_timer = $Timer

const base_outline = 0.4

@onready var collision_area = $Area2D

var fixed = false

var can_grab = false
var grabbed_offset = Vector2()

var grabbed = false

const SPEED = 20.0

var last_available_position = Vector2.ZERO
var previous_available_position = Vector2.ZERO

var overlapping_bodies = []

signal fit_to_grid

func _ready():
	last_available_position = position
	previous_available_position = position

func _input_event(_viewport, event, _shape_idx):
	if fixed: return
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()
	if event is InputEventMouseMotion and not grabbed:
		can_grab = false
		grab_timer.stop()

func _process(_delta):
	if fixed: return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_grab:
		if not grabbed and grab_timer.is_stopped():
			grab_timer.start()
		elif grabbed:
			#position = position.move_toward(get_global_mouse_position() + grabbed_offset, SPEED)
			position = get_global_mouse_position() + grabbed_offset
			make_fit()
	else:
		if grabbed:
			make_fit()
			fit_check()
		grab_timer.stop()
		grabbed = false
		can_grab = false
		outline_width(0.0)

func _on_timer_timeout():
	grabbed = true
	outline_width(base_outline)

func outline_width(value: float) -> void:
	sprite.material.set_shader_parameter("width", value)

func make_fit():
	emit_signal("fit_to_grid", self)
	var collisions = collision_area.get_overlapping_bodies()
	collisions.erase(self)
	if collisions.is_empty():
		if last_available_position != position:
			previous_available_position = last_available_position
		last_available_position = position

func fit_check():
	var collisions = collision_area.get_overlapping_bodies()
	collisions.erase(self)
	if collisions.is_empty():
		if last_available_position != position:
			previous_available_position = last_available_position
		last_available_position = position
	else:
		position = previous_available_position

func reset_position():
	position = last_available_position
