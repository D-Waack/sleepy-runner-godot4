extends StaticBody2D

signal player_hit

func _on_area_2d_body_entered(body):
	if body is Player: 
		emit_signal("player_hit")
