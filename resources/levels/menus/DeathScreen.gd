extends Control

onready var click_noise = $Click


func _on_Button_button_down():
	click_noise.stream.loop = false
	click_noise.play()
	$AnimationPlayer.play("fade")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://resources/menus/TitleScreen.tscn")
