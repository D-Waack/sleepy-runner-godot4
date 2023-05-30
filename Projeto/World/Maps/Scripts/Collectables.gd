extends Node2D

signal item_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in get_children():
		item.connect("collected", _on_Collectable_collected)

func _on_Collectable_collected(item_type):
	emit_signal("item_collected", item_type)
