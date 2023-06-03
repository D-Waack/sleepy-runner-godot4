extends Node

# Sons globais
@onready var click_sound = $ClickSound
@onready var enemy_death_sound = $EnemyDeathSound
@onready var crystal_break_sound = $CrystalBreakSound

func play_option():
	click_sound.play()

func play_enemy_death():
	enemy_death_sound.play()

func play_crystal_break():
	crystal_break_sound.play()
