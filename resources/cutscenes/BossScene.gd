extends Node2D

func _ready():
	$Transition.trans_to_normal()
	$Timer.start()

func _on_Timer_timeout():
	$AnimationPlayer.play("fade")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://resources/levels/Bossroom.tscn")
