extends Node2D


func _physics_process(delta):
	if ! $Boss:
		$AnimationPlayer.play("fade")
		


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://resources/cutscenes/WinScene.tscn")
