extends Area2D


func _on_Area2D_body_entered(body):
	if body is Player:
		Global.player_x = 3216
		Global.player_y = -770
		Global.health = body.hp
		get_tree().change_scene("res://resources/levels/Grassland.tscn")
