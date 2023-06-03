extends Enemy

func _ready():
	tween_values[0] = position.y
	tween_values[1] += position.y
	sprite.play("default")
	start_tween()

func start_tween():
	tween = create_tween()
	tween.tween_property(self, "position:y", tween_values[1], 0.3)
	await tween.finished
	tween.kill()
	tween_values.reverse()
	start_tween()
	#tween_property(object: Object, property: NodePath, final_val: Variant, duration: float)

func _on_hitbox_body_entered(body):
	if body is Player:
		emit_signal("kill_player")

func kill():
	SoundManager.play_enemy_death()
	queue_free()
