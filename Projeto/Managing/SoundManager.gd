extends Node

# Sons globais
@onready var click_sound = $ClickSound

func play_option():
	click_sound.play()
