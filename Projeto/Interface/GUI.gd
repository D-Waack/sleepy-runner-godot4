extends Control

# Variáveis de nós
@onready var level_edit = $CanvasLayer/LevelEdit
@onready var run = $CanvasLayer/Run
@onready var pause = $CanvasLayer/Pause
@onready var victory_panel = $CanvasLayer/VictoryPanel
@onready var shine_display = $CanvasLayer/VictoryPanel/ShineDisplay
@onready var puzzle_display = $CanvasLayer/VictoryPanel/PuzzleDisplay
@onready var rank = $CanvasLayer/VictoryPanel/Rank

# constantes
const tile_size = 16

# Sinal para o botão de play
signal play_button_pressed
signal restart_button_pressed
signal pause_button_pressed
signal jump_button_pressed
signal resume_button_pressed
signal edit_button_pressed
signal exit_button_pressed

signal save_game
signal back_to_stage_select

# Emite o sinal para o botão de play
func _on_play_button_button_up():
	emit_signal("play_button_pressed")

func _on_restart_button_button_up():
	emit_signal("restart_button_pressed")

func _on_pause_button_button_up():
	emit_signal("pause_button_pressed")

func _on_jump_button_button_up():
	emit_signal("jump_button_pressed")

func _on_resume_button_button_up():
	emit_signal("resume_button_pressed")

func _on_edit_button_button_up():
	emit_signal("edit_button_pressed")

func _on_exit_button_button_up():
	emit_signal("exit_button_pressed")

# Retorna a visibilidade dos botões de edição
func set_level_edit():
	level_edit.set_visible(true)
	pause.set_visible(false)
	run.set_visible(false)

func set_run():
	level_edit.set_visible(false)
	run.set_visible(true)
	pause.set_visible(false)

func set_pause():
	level_edit.set_visible(false)
	run.set_visible(false)
	pause.set_visible(true)

# Mostra o painel de vitória provisório
func show_victory(shine_count, puzzle_get):
	victory_panel.set_visible(true)
	if shine_count > 0:
		shine_display.set_size(Vector2(shine_count * tile_size, tile_size))
	else:
		shine_display.set_visible(false)
	if puzzle_get:
		puzzle_display.set_size(Vector2(tile_size, tile_size))
	else:
		puzzle_display.set_visible(false)
	
	rank.text = "\n[center]" + str(GlobalVariables.calculate_rank(shine_count, puzzle_get))

func _on_texture_button_button_up():
	emit_signal("save_game")
	emit_signal("back_to_stage_select")
