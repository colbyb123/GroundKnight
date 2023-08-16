extends Node2D

const SceneTwo = preload("res://resources/cutscenes/SceneTwo.tscn")
const LastScene = preload("res://resources/cutscenes/LastScene.tscn")

func _ready():
	$Transition.trans_to_normal()
	$Timer.start()


func _on_Transition_done():
	$Scene.get_child(0).queue_free()
	
	if $Scene.get_child(0).filename == "res://resources/cutscenes/HomeScene.tscn":
		$Scene.add_child(SceneTwo.instance())
	elif $Scene.get_child(0).filename == "res://resources/cutscenes/SceneTwo.tscn":
		$Scene.add_child(LastScene.instance())
	elif $Scene.get_child(0).filename == "res://resources/cutscenes/LastScene.tscn":
		get_tree().change_scene("res://resources/levels/Grassland.tscn")
	$Timer.start()

func _on_Timer_timeout():
	$Transition.transition()

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		$AnimationPlayer.play("fade")
		


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://resources/levels/Grassland.tscn")
