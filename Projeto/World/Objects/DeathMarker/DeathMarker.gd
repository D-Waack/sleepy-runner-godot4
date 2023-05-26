extends Area2D

@onready var sprite = $Sprite2D

# Ficar transparente caso o mouse esteja perto
func _on_mouse_entered():
	if not visible: return
	sprite.set_modulate(Color(Color.WHITE,0.2))

func _on_mouse_exited():
	if not visible: return
	sprite.set_modulate(Color(Color.WHITE,0.8))
