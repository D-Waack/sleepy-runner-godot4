extends Control

@onready var play_button = $CanvasLayer/PlayButton
@onready var victory_panel = $CanvasLayer/VictoryPanel


signal play_button_pressed

func _on_play_button_button_up():
	emit_signal("play_button_pressed")
	play_button.set_visible(false)

func soft_reset():
	play_button.set_visible(true)

func show_victory():
	victory_panel.set_visible(true)
