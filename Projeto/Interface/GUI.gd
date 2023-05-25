extends Control

# Variáveis de nós
@onready var play_button = $CanvasLayer/PlayButton
@onready var victory_panel = $CanvasLayer/VictoryPanel
@onready var shine_display = $CanvasLayer/VictoryPanel/ShineDisplay
@onready var puzzle_display = $CanvasLayer/VictoryPanel/PuzzleDisplay

# constantes
const tile_size = 16

# Sinal para o botão de play
signal play_button_pressed

# Emite o sinal para o botão de play
func _on_play_button_button_up():
	emit_signal("play_button_pressed")
	play_button.set_visible(false)

# Retorna a visibilidade dos botões de edição
func soft_reset():
	play_button.set_visible(true)

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
