extends StaticBody2D

## Variaveis de nós
@onready var sprite = $Sprite2D
@onready var grab_timer = $Timer
@onready var collision_area = $Area2D
@onready var map = $Map
@onready var obstacles = $Obstacles
@onready var collectables = $Collectables

# Constantes de shader
const base_outline = 0.4

# Variáveis de controle
var fixed = false
var can_grab = false
var grabbed = false
var overlapping_bodies = []

# Variáveis e constantes de cálculo de arrasto
const SPEED = 20.0
var grabbed_offset = Vector2()

# Variáveis de controle de posição
var last_available_position = Vector2.ZERO
var previous_available_position = Vector2.ZERO

# Sinal para encaixar objeto na grid
signal fit_to_grid
signal kill_player
signal item_collected

# Função de inicialização. Configura posições iniciais
func _ready():
	last_available_position = position
	previous_available_position = position
	map.set_layer_enabled(1, false)
	map.set_layer_modulate(1, Color.RED)
	
	for obstacle in obstacles.get_children():
		obstacle.connect("player_hit", _on_obstacle_player_hit)
	
	for collectable in collectables.get_children():
		collectable.connect("collected", _on_Collectable_collected)

# Função roda toda vez que existe algum input do jogador
func _input_event(_viewport, event, _shape_idx):
	if fixed: return
	if event is InputEventMouseButton: 
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()
	if event is InputEventMouseMotion and not grabbed: # se mover antes de selecionar, cancelar seleção
		can_grab = false
		grab_timer.stop()

# Função roda todo frame
func _process(_delta):
	if fixed: return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_grab:
		if not grabbed and grab_timer.is_stopped():
			grab_timer.start()
		elif grabbed:
			position = get_global_mouse_position() + grabbed_offset
			make_fit()
	else:
		if grabbed:
			#make_fit()
			fit_check()
		grab_timer.stop()
		grabbed = false
		can_grab = false
		outline_width(0.0)

# Caso timer para seleção acabe normalmente, selecionar o objeto
func _on_timer_timeout():
	grabbed = true
	outline_width(base_outline)

# Ativa ou desativa shader para visualização de seleção
func outline_width(value: float) -> void:
	sprite.material.set_shader_parameter("width", value)
	if value > 0:
		map.set_layer_enabled(1, true)
	else:
		map.set_layer_enabled(1, false)

# Emite sinal para que o objeto possa alcançar a posição esperada na grid
func make_fit():
	emit_signal("fit_to_grid", self)
	var collisions = collision_area.get_overlapping_bodies()
	collisions.erase(self)
	collisions.erase(map)
	if collisions.is_empty():
		if last_available_position != position:
			previous_available_position = last_available_position
		last_available_position = position

# Verifica se o objeto foi largado em uma posição inadequada
func fit_check():
	var collisions = collision_area.get_overlapping_bodies()
	collisions.erase(self)
	collisions.erase(map)
	if collisions.is_empty():
		if last_available_position != position:
			previous_available_position = last_available_position
		last_available_position = position
	else:
		position = previous_available_position

# Faz o reset da posição do objeto para a última posição disponível
func reset_position():
	position = last_available_position

func _on_obstacle_player_hit():
	emit_signal("kill_player")

func _on_Collectable_collected(type):
	emit_signal("item_collected", type)
