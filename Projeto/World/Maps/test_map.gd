extends Node2D

# Variaveis de nós
## Objetos, limites e mapa
@onready var tilemap = $Map
@onready var objects = $Objects

## Personagens, câmera
@onready var camera = $Camera
@onready var player = $Player

## Interface gráfica
@onready var interface = $GUI

# Variáveis de controle e máquina de estados
enum control_states {PREPARE, SELECT, RUN, VICTORY} # estados da máquina
var current_state = 0 # estado atual

var play_pressed = false # controle entre edição de mapa e execução

# Variáveis de posicionamento
const limit_top = 0.0 # não muda, pode ser constante
var limit_left = 0.0 # mudada para controlar posição inicial horizontal da câmera
@onready var limit_bottom = $Boundaries/BottomBoundary.position.y # anotação @onready porque precisa da posição de um nó em Boundaries
@onready var limit_right = $Boundaries/RightBoundary.position.x

@onready var player_position = player.position # Posição original do personagem jogável

# Constantes da câmera 
const object_drag_camera_ratio = 2.0 # velocidade de deslize da câmera
const right_drag_threshold = 0.85 # porcentagem máxima da tela para deslize durante arrasto de objeto
const left_drag_threshold = 0.15 # porcentagem mínima da tela para deslize durante arrasto de objeto

# Configuração inicial
func _ready():
	# Limites da câmera são configurados
	camera.limit_left = limit_left
	camera.limit_bottom = limit_bottom
	camera.limit_top = limit_top
	camera.limit_right = limit_right
	
	# Posição inicial da câmera é configurada
	camera.position = player.position
	
	# Limite esquerdo da câmera é ajustado
	limit_left += get_viewport().get_visible_rect().size.x / 2

# Roda todo frame
func _process(_delta):
	# Estado atual é configurado
	set_current_state()
	
	# Ajuste da posição da câmera
	adjust_camera_position()
	
	# Ajuste de variáveis para cada estado (match = switch case) 
	match current_state:
		control_states.PREPARE:
			camera.can_drag = true
		control_states.SELECT:
			camera.can_drag = false
		control_states.RUN:
			camera.follow_along(player)
	
	# Checks de estado
	if player.position.y > limit_bottom:
		player.kill() 

# Subrotinas de Process
## Configura estado atual com base em algumas condições
func set_current_state():
	if objects.has_grabbed:
		current_state = control_states.SELECT
	elif play_pressed:
		current_state = control_states.RUN
	else:
		current_state = control_states.PREPARE

## Ajuste da posição da câmera para que não passe dos limites
func adjust_camera_position():
	camera.position.x = max(limit_left, camera.position.x)
	camera.position.y = min(limit_top, camera.position.y)
	camera.position.y = max(limit_bottom, camera.position.y)

# Funções de sinais
## Quando o personagem morre
func _on_player_dead(): # soft reset 
	# voltar ao estado de edição
	current_state = control_states.PREPARE
	play_pressed = false
	
	# objetos permitem edição outra vez
	objects.block_grabbing(false)
	
	# player volta ao seu lugar
	player.position = player_position
	
	# interface é resetada
	interface.soft_reset()

## Quando botão de play é pressionado
func _on_gui_play_button_pressed():
	# objetos bloqueiam edição
	objects.block_grabbing(true)
	
	# update em variáveis de controle
	play_pressed = true
	camera.can_drag = false
	
	# movimento e física do player são liberados
	player.reset_start()

## Quando arrastando um objeto, encaixar ele na grid
func _on_objects_fit_to_grid(object):
	# Se posição do arrasto na tela é maior que os thresholds, arrastar a tela
	if get_viewport().get_mouse_position().x > get_viewport().get_visible_rect().size.x * right_drag_threshold:
		camera.position.x += object_drag_camera_ratio
	elif get_viewport().get_mouse_position().x < get_viewport().get_visible_rect().size.x * left_drag_threshold:
		camera.position.x = max(camera.position.x - object_drag_camera_ratio, 0)
	
	# Cálculo de posição na grid do tilemap para fazer o snap/encaixe
	var current_position = tilemap.to_local(object.position)
	var map_position = tilemap.local_to_map(current_position)
	var next_position = tilemap.map_to_local(map_position)
	next_position = Vector2(next_position.x - tilemap.tile_set.tile_size.x/2, next_position.y - tilemap.tile_set.tile_size.y/2)
	
	# Checando se a posição está dentro dos limites. Se está, atualizar a posição. Se não, resetar a posição
	if next_position.y < limit_bottom and next_position.y > -16 and next_position.x > -16:
		object.position = next_position
	else:
		object.reset_position()

## Quando o personagem alcança a bandeira
func _on_goal_goal_reached():
	# Update para o estado de vitória
	current_state = control_states.VICTORY
	
	# Mostrar a tela de vitória
	interface.show_victory()
