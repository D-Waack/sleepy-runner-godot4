extends Node2D

# Variaveis de nós
## Objetos, limites e mapa
@onready var tilemap = $Map
@onready var objects = $Platforms
@onready var marker = $DeathMarker
@onready var obstacles = $Obstacles
@onready var collectables = $Collectables
@onready var platforms = $Platforms

## Personagens, câmera
@onready var camera = $Camera
@onready var player = $Player

## Interface gráfica
@onready var interface = $GUI

## Audio
@onready var get_sound = $Audio/GetSound
@onready var clapping = $Audio/Clapping
@onready var clap1 = preload("res://World/Maps/Common/clapping_1.wav")
@onready var clap2 = preload("res://World/Maps/Common/clapping_2.wav")
@onready var clap3 = preload("res://World/Maps/Common/clapping_3.wav")

# Variáveis de controle e máquina de estados
enum control_states {PREPARE, SELECT, RUN, VICTORY, PAUSE} # estados da máquina
var current_state = 0 # estado atual

var play_pressed = false # controle entre edição de mapa e execução

var min_marker_distance = 32.0 

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

# Variáveis de status
var time_taken = 0.0
var shines_collected = 0
var puzzle_collected = false
var rank = 'C'

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
			interface.set_level_edit()
			camera.can_drag = false
		control_states.RUN:
			camera.can_drag = false
			interface.set_run()
			camera.follow_along(player)
		# Pause não roda, pois a execução fica pausada
#		control_states.PAUSE: 
#			interface.set_pause()
	
	# Checks de estado
	if player.position.y > limit_bottom:
		kill_player()

# Subrotinas de Process
## Configura estado atual com base em algumas condições
func set_current_state():
	if current_state == control_states.VICTORY: return
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

## Faz o processo para matar o player
func kill_player():
	if current_state == control_states.VICTORY: return
	var nearby_marker = false
	if player.position.distance_to(marker.position) <= min_marker_distance:
		nearby_marker = true
	if not nearby_marker:
		marker.position = Vector2(player.position.x, player.position.y - 10)
		marker.sprite.set_modulate(Color(Color.WHITE,0.8))
		marker.set_visible(true)
	player.kill()
	collectables.uncollect()
	platforms.uncollect()
	
	shines_collected = 0
	puzzle_collected = false

# Funções de sinais
## Quando o personagem morre
func _on_player_dead(): # soft reset 
	# voltar ao estado de edição
	current_state = control_states.PREPARE
	play_pressed = false
	
	# objetos permitem edição outra vez
	objects.block_grabbing(false)
	
	# update da interface
	interface.set_level_edit()
	
	# player volta ao seu lugar
	player.position = player_position

## Quando botão de play é pressionado
func _on_gui_play_button_pressed():
	# objetos bloqueiam edição
	objects.block_grabbing(true)
	
	# update em variáveis de controle
	camera.can_drag = false
	
	# fazer com que os markers desapareçam
	marker.set_visible(false)
	
	# volta a câmera a posição inicial
	var tween = create_tween()
	tween.tween_property(camera, "position:x", player.position.x, 0.5)
	tween.tween_property(camera, "position:x", player.position.x, 0.2)
	await tween.finished
	
	# segundo update para variáveis de controle
	play_pressed = true
	
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
	if next_position.y < limit_bottom and next_position.y > -tilemap.tile_set.tile_size.y and next_position.x > -tilemap.tile_set.tile_size.y:
		object.position = next_position
	else:
		object.reset_position()

## Quando o personagem alcança a bandeira
func _on_goal_goal_reached():
	# Update para o estado de vitória
	current_state = control_states.VICTORY
	
	# Mostrar a tela de vitória
	interface.show_victory(shines_collected, puzzle_collected)

## Quando o personagem colidir com algum obstáculo
func _on_platforms_kill_player():
	kill_player()

func _on_collectables_item_collected(item_type):
	get_sound.play()
	match item_type:
		0:
			shines_collected += 1
		1:
			puzzle_collected = true

func _on_gui_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_gui_jump_button_pressed():
	player.jumped = true

func _on_gui_edit_button_pressed():
	interface.set_level_edit()
	kill_player()
	get_tree().paused = false

func _on_gui_pause_button_pressed():
	interface.set_pause()
	get_tree().paused = true

func _on_gui_resume_button_pressed():
	get_tree().paused = false

func _on_gui_exit_button_pressed():
	get_tree().change_scene_to_file("res://World/Maps/StageSelect/StageSelect.tscn")

func _on_gui_save_game():
	var current_stats = SaveManager.stats.world1[GlobalVariables.current_stage_index]
	var best_rank = GlobalVariables.calculate_best_rank(rank,current_stats[2])
	var best_puzzle = puzzle_collected if puzzle_collected else current_stats[1]
	var best_shine = shines_collected
	if current_stats[0] > shines_collected:
		best_shine = current_stats[0]
	SaveManager.stats.world1[GlobalVariables.current_stage_index] = [best_shine, best_puzzle, best_rank]
	SaveManager.write_savegame()

func _on_gui_back_to_stage_select():
	get_tree().change_scene_to_file("res://World/Maps/StageSelect/StageSelect.tscn")

func _on_triggers_trigger_broken():
	obstacles.destroy_wall()

func _on_enemies_kill_player():
	kill_player()

func _on_gui_rank_update(new_rank):
	rank = new_rank
	match rank:
		'S', 'S+':
			clapping.stream = clap1
		'A', 'B':
			clapping.stream = clap2
			clapping.volume_db = 22.0
		_:
			clapping.stream = clap3
			clapping.volume_db = 22.0
	
	clapping.play()
