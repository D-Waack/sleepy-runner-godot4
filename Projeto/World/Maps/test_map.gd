extends Node2D

@onready var tilemap = $TileMap
@onready var tilemap2 = $TileMap2

var mouse_on_player = false

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_position = get_global_mouse_position()
		var tile_position = tilemap2.local_to_map(tilemap2.to_local(mouse_position))
		
		if mouse_on_player:
			return
		
		if tilemap.get_cell_source_id(0, tile_position) == -1 and tilemap2.get_cell_source_id(0, tile_position):
			tilemap2.set_cell(0,tile_position,0, Vector2i(0,0))
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var mouse_position = get_global_mouse_position()
		var tile_position = tilemap2.local_to_map(tilemap2.to_local(mouse_position))
		
		if tilemap2.get_cell_source_id(0, tile_position) == 0:
			tilemap2.set_cell(0,tile_position,-1, Vector2i(0,0))

func _on_player_mouse_in(is_on_player):
	mouse_on_player = is_on_player
