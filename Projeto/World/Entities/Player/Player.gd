extends CharacterBody2D

# Declaração de classe
class_name Player

# Constantes e variáveis físicas
const SPEED = 210.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variáveis de controle
var facing_direction = 1

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

	if is_on_wall():
		facing_direction *= -1

	var direction = facing_direction
	velocity.x = direction * SPEED

	move_and_slide()

# "Mata" o personagem quando necessário
func kill():
	set_physics_process(false)
	emit_signal("dead")

# Reinicia o processo físico e reseta o personagem à posição padrão
func reset_start():
	set_physics_process(true)
	facing_direction = 1
