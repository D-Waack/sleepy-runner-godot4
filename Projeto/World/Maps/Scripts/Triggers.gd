extends Node2D

signal trigger_broken

func _ready():
	for trigger in get_children():
		trigger.connect("destroyed", _on_Trigger_destroyed)

func _on_Trigger_destroyed():
	emit_signal("trigger_broken")

func unbreak():
	for trigger in get_children():
		trigger.break_trigger(false)
