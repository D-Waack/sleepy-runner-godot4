extends CharacterBody2D

# Declaração de classe
class_name Player

# Timers
@onready var bow_timer = $Bow/BowTimer
@onready var bow_hold_timer = $Bow/BowHoldTimer
@onready var bow_cooldown = $BowCooldown

# Objects
@onready var bow = $Bow

# Variáveis de animação
@onready var animator = $AnimationTree.get("parameters/playback")
@onready var sprite = $Sprite2D

# Constantes e variáveis físicas
var SPEED = 160.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variáveis de controle
var facing_direction = 1
var just_died = false
var jumped = false
var falling_threshold = -10.0
@export var animation = false
var can_aim = true
var bow_held = false

# Sinais
signal dead

# Desativa o processo físico no início da execução
func _ready():
	set_physics_process(false)

# Roda a todo frame. Verificações e cálculos de física
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not animation:
		velocity.y = JUMP_VELOCITY
	elif jumped and is_on_floor():
		velocity.y = JUMP_VELOCITY
	jumped = false

	if Input.is_action_pressed("aim") and not animation:
		if can_aim and not bow_held:
			if bow_timer.is_stopped():
				bow_timer.start()
		if bow_held:
			bow.rotation_degrees = rad_to_deg(get_angle_to(get_global_mouse_position()))
	else:
		bow_timer.stop()
		if bow_held:
			release_bow()

	if is_on_wall():
		if just_died:
			just_died = false
		else:
			velocity.y = JUMP_VELOCITY/2
			facing_direction *= -1

	var direction = facing_direction
	velocity.x = direction * SPEED

	move_and_slide()
	animate()

# "Mata" o personagem quando necessário
func kill():
	animator.travel("idle")
	sprite.flip_h = false
	set_physics_process(false)
	emit_signal("dead")
	jumped = false
	velocity.y = 0

# Reinicia o processo físico e reseta o personagem à posição padrão
func reset_start():
	set_physics_process(true)
	facing_direction = 1
	just_died = true

func animate():
	if facing_direction == 1:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	if velocity == Vector2.ZERO:
		animator.travel("idle")
		return
	if not is_on_floor():
		if velocity.y < falling_threshold:
			animator.travel("rise")
			return
		animator.travel("fall")
		return
	animator.travel("run")

func release_bow():
	Engine.time_scale = 1.0
	bow.set_visible(false)
	bow_held = false
	can_aim = false
	bow_cooldown.start()

func _on_bow_timer_timeout():
	bow_held = true
	bow_hold_timer.start()
	Engine.time_scale = 0.3
	bow.set_visible(true)

func _on_bow_hold_timer_timeout():
	release_bow()

func _on_bow_cooldown_timeout():
	can_aim = true

