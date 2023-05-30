extends Node2D

@onready var stages = $Stages

func _ready():
	var stats = SaveManager.stats
	for stage in stages.get_children():
		stage.set_stat(stats.world1[stage.stage_index])
