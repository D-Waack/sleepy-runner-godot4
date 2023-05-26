extends CharacterBody2D

# Declaração de classe
class_name Player

# Constantes e variáveis físicas
const SPEED = 210.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variáveis de controle
var facing_direction = 1
var just_died = false
var jumped = false

# Sinais
signal dead

# Desativa o processo físico no início da execução
func _ready():
	set_physics_process(false)

# Roda a todo frame. Verificações e cálculos de física
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif jumped and is_on_floor():
		velocity.y = JUMP_VELOCITY
	jumped = false

	if is_on_wall():
		if just_died:
			just_died = false
		else:
			velocity.y = JUMP_VELOCITY/2
			facing_direction *= -1

	var direction = facing_direction
	velocity.x = direction * SPEED

	move_and_slide()

# "Mata" o personagem quando necessário
func kill():
	set_physics_process(false)
	emit_signal("dead")
	jumped = false
	velocity.y = 0

# Reinicia o processo físico e reseta o personagem à posição padrão
func reset_start():
	set_physics_process(true)
	facing_direction = 1
	just_died = true
