extends CharacterBody2D

# Declaração de classe
class_name Player

# Timers
@onready var bow_timer = $Bow/BowTimer
@onready var bow_hold_timer = $Bow/BowHoldTimer
@onready var bow_cooldown = $BowCooldown

# Objetos
@onready var bow = $Bow
@onready var bow_sprite = $Bow/Sprite
@onready var Arrow = preload("res://World/Entities/Player/Arrow/Arrow.tscn")

# Sounds
@onready var jump_sound = $Sounds/JumpSound
@onready var death_sound = $Sounds/DeathSound
@onready var arrow_sound = $Sounds/ArrowSound

# Variáveis de animação
@onready var animator = $AnimationTree.get("parameters/playback")
@onready var sprite = $Sprite2D

# Constantes e variáveis físicas
var SPEED = 160.0
const JUMP_VELOCITY = -360.0

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
	floor_snap_length = 3.0
	floor_constant_speed = true

# Roda a todo frame. Verificações e cálculos de física
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not animation:
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
	elif jumped and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
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
			jump_sound.play()

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
	death_sound.play()

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
	arrow_sound.play()
	
	Engine.time_scale = 1.0
	bow.set_visible(false)
	bow_held = false
	can_aim = false
	bow_cooldown.start()
	
	var new_arrow = Arrow.instantiate()
	get_tree().current_scene.add_child(new_arrow)
	new_arrow.position = position
	new_arrow.rotation_degrees = bow.rotation_degrees
	new_arrow.direction = Vector2.RIGHT.rotated(bow.rotation)
	new_arrow.set_physics_process(true)

func _on_bow_timer_timeout():
	bow_held = true
	bow_hold_timer.start()
	Engine.time_scale = 0.3
	bow.set_visible(true)

func _on_bow_hold_timer_timeout():
	if bow_held:
		release_bow()

func _on_bow_cooldown_timeout():
	can_aim = true
