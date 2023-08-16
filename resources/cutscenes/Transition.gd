extends CanvasLayer

signal done

onready var anim = $AnimationPlayer

func transition():
	anim.play("fade_to_black")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("done")
		anim.play("fade_to_normal")

func trans_to_normal():
	anim.play("fade_to_normal")

