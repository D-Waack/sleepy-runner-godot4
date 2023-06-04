extends Node2D

class_name Enemy

@onready var tween_values = [0, 6]
@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var hitbox_collision_shape = $Hitbox/CollisionShape2D2

var tween 

signal kill_player

var killed = false

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
	die(true)

func die(flag: bool):
	killed = flag
	set_visible(not flag)
	collision_shape.set_deferred("disabled", flag)
	hitbox_collision_shape.set_deferred("disabled", flag)
