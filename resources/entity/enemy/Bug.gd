extends "res://resources/entity/EntityBase.gd"

var velocity : Vector2
export var max_speed : int = 100
export var gravity : float = 55
export var acceleration : int = 50


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity
		if velocity.y > 2000:
			velocity.y = 2000
	
	if is_on_wall():
		acceleration = -acceleration
		$AnimatedSprite.scale.x *= -1
	
	velocity.x += acceleration
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	
	velocity = move_and_slide(velocity, Vector2.UP)
