extends Node2D

# Variável de controle
var has_grabbed # objeto foi selecionado

# Sinal para update de posição
signal fit_to_grid

# Função roda na inicialização do nó. Conectando sinal todos os objetos filhos automaticamente
func _ready():
	for object in get_children():
		object.connect("fit_to_grid", _on_Object_fit_to_grid)

# Função roda a todo frame
func _process(_delta):
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): # botão não foi apertado
		has_grabbed = false
		return
	for object in get_children(): # verificando se algum objeto filho está selecionado
		if object.grabbed:
			has_grabbed = true
			return
	has_grabbed = false 

# Bloqueia função de seleção 
func block_grabbing(condition):
	for object in get_children():
		object.fixed = condition

# Emite sinal acima de fit_to_grid dos objetos acima para o mapa
func _on_Object_fit_to_grid(object):
	emit_signal("fit_to_grid", object)
