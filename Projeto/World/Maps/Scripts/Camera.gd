extends Camera2D

# Variáveis de posição para arrasto de tela
var mouse_start_pos
var screen_start_position

# Variáveis de controle de ações
var can_drag = false
var dragging = false

# Roda toda vez que há algum input do jogador (toque, mouse, teclado, controle)
func _input(event):
	if not can_drag: # se can_drag é falso, não faça nada
		dragging = false
		return
	if event is InputEventMouseButton: # evento botão do mouse
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging: # evento movimento do mouse
		position = zoom * (mouse_start_pos - event.position) + screen_start_position

# Função faz o update da posição da câmera com base em um objeto "target", geralmente o personagem jogável
func follow_along(target):
	position = target.position
