extends Area2D



func _on_Area2D_body_entered(body):
	if body is Player:
		Global.health = body.hp
		Global.player_x = -2400
		Global.player_y = -60
		get_tree().change_scene("res://resources/levels/Rockland.tscn")
