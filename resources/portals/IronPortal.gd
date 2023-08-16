extends Area2D





func _on_Area2D2_body_entered(body):
	if body is Player:
		Global.health = body.hp
		Global.player_x = 0
		Global.player_y = 0
		get_tree().change_scene("res://resources/levels/Ironland.tscn")
