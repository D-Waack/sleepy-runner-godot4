extends Node2D

signal kill_player

func _ready():
	for enemy in get_children():
		enemy.connect("kill_player", _on_Enemy_kill_player)

func _on_Enemy_kill_player():
	emit_signal("kill_player")

func unkill():
	for enemy in get_children():
		enemy.die(false)
