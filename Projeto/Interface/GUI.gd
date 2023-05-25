extends Control

# Variáveis de nós
@onready var play_button = $CanvasLayer/PlayButton
@onready var victory_panel = $CanvasLayer/VictoryPanel

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
func show_victory():
	victory_panel.set_visible(true)
