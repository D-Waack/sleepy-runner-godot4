extends Node2D

@onready var camera = $Camera2D
@onready var player = $Player
@onready var objects = $Objects

@onready var tilemap = $TileMap

@onready var interface = $GUI

var limit_left = 0.0
const limit_top = 0.0
@onready var limit_bottom = $Boundaries/BottomBoundary.position.y
@onready var limit_right = $Boundaries/RightBoundary.position.x

enum control_states {PREPARE, SELECT, RUN, VICTORY}

var current_state = 0

var play_pressed = false

@onready var player_position = player.position

const object_drag_camera_ratio = 2.0

func _ready():
	camera.limit_left = limit_left
	camera.limit_bottom = limit_bottom
	camera.limit_top = limit_top
	camera.limit_right = limit_right
	camera.position = player.position
	
	limit_left += get_viewport().get_visible_rect().size.x / 2

func _process(_delta):
	get_current_state()
	
	camera.position.x = max(limit_left, camera.position.x)
	camera.position.y = min(limit_top, camera.position.y)
	camera.position.y = max(limit_bottom, camera.position.y)
	
	match current_state:
		control_states.PREPARE:
			camera.can_drag = true
		control_states.SELECT:
			camera.can_drag = false
		control_states.RUN:
			camera.follow_along(player)
	
	if player.position.y > limit_bottom:
		player.kill()

func get_current_state():
	if objects.has_grabbed:
		current_state = control_states.SELECT
	elif play_pressed:
		current_state = control_states.RUN
	else:
		current_state = control_states.PREPARE

func _on_player_dead(): # soft reset
	current_state = control_states.PREPARE
	player.position = player_position
	interface.soft_reset()
	objects.block_grabbing(false)
	play_pressed = false

func _on_gui_play_button_pressed():
	play_pressed = true
	player.reset_start()
	objects.block_grabbing(true)
	camera.can_drag = false

func _on_objects_fit_to_grid(object):
	if get_viewport().get_mouse_position().x > get_viewport().get_visible_rect().size.x * 0.85:
		camera.position.x += object_drag_camera_ratio
	elif get_viewport().get_mouse_position().x < get_viewport().get_visible_rect().size.x * 0.15:
		camera.position.x = max(camera.position.x - object_drag_camera_ratio, 0)
	
	var current_position = tilemap.to_local(object.position)
	var map_position = tilemap.local_to_map(current_position)
	var next_position = tilemap.map_to_local(map_position)
	next_position = Vector2(next_position.x - tilemap.tile_set.tile_size.x/2, next_position.y - tilemap.tile_set.tile_size.y/2)
	
	if next_position.y < limit_bottom and next_position.y > -16 and next_position.x > -16:
		object.position = next_position
	else:
		object.reset_position()

func _on_goal_goal_reached():
	current_state = control_states.VICTORY
	interface.show_victory()
