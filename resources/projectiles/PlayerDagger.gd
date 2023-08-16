extends "res://resources/overlap/Hitbox.gd"

export(int) var SPEED: int = 600

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta

func destroy():
	queue_free()

func _on_PlayerDagger_area_entered(area):
	if ! area is Area2D:
		destroy()

func _on_PlayerDagger_body_entered(body):
	if body is TileMap:
		SPEED = 0
	else:
		destroy()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
