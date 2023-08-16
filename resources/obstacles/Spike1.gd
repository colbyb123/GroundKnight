extends "res://resources/entity/EntityBase.gd"

onready var pos = $Position2D
var x
var y

func _ready():
	x = pos.global_position.x
	y = pos.global_position.y

func _on_Area2D_body_entered(body):
	if body is Player:
		body.reset(x,y)
