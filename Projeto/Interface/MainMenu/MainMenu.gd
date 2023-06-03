extends Control

@onready var player = $Player
@onready var animator = $AnimationPlayer
@onready var audio = $AudioStreamPlayer

func _ready():
	SaveManager.prepare_save()
	audio.play()
	animator.play("run")
	player.set_physics_process(true)
	player.SPEED = 120.0

func player_jump():
	player.jumped = true
	player.animator.travel("rise")

func adjust_player():
	player.facing_direction = -1
	player.position = Vector2(350, 66)

func adjust_player2():
	player.facing_direction = 1
	player.position = Vector2(-15, 178)

func _on_start_button_button_up():
	get_tree().change_scene_to_file("res://World/Maps/StageSelect/StageSelect.tscn")

func _on_quit_button_button_up():
	get_tree().quit()

func _on_delete_save_button_button_up():
	if not SaveManager.save_exists(): return
	SaveManager.delete_savegame()
	get_tree().reload_current_scene()
