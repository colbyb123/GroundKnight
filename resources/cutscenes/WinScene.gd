extends Node2D

func _ready():
	$Transition.trans_to_normal()

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		$AnimationPlayer.play("fade")
		
		
func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://resources/cutscenes/GodotCredits.tscn")
