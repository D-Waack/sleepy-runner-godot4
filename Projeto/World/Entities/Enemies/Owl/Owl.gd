extends CharacterBody2D

@onready var animator = $AnimationPlayer

func _ready():
	animator.play("idle")

func _on_hitbox_body_entered(body):
	if body is Player:
		body.kill()
