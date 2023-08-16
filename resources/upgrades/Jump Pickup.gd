extends Node2D




func _on_Area2D_body_entered(body):
	if body is Player:
		body.set_jump_count(2)
		queue_free()
