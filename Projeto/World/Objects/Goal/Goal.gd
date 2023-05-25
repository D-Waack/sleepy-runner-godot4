extends Area2D

signal goal_reached

# Se um corpo entrar e for player, emitir sinal de vitória
func _on_body_entered(body):
	if body is Player:
		emit_signal("goal_reached")
