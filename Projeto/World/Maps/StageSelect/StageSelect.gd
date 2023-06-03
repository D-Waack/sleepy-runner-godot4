extends Node2D

@onready var stages = $Stages
@onready var bgm = $BGM

func _ready():
	bgm.play()
	var stats = SaveManager.stats
	for stage in stages.get_children():
		stage.set_stat(stats.world1[stage.stage_index])
		stage.connect("change_scene", _on_StageIcon_change_scene)

func _on_return_button_button_up():
	SoundManager.play_option()
	get_tree().change_scene_to_file("res://Interface/MainMenu/MainMenu.tscn")

func _on_StageIcon_change_scene(stage_index, stage_scene):
	SoundManager.play_option()
	GlobalVariables.current_stage_index = stage_index
	get_tree().change_scene_to_packed(stage_scene)
