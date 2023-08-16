extends "res://resources/entity/EntityBase.gd"

enum {
	IDLE,
	WANDER,
	HUNT
}

var state = IDLE
var player = null
onready var wait_timer = $RoamTimer

var velocity = Vector2.ZERO
const ACCELERATION = 300
const MAX_SPEED = 150
const TOLERANCE = 4.0

onready var start_position = global_position
onready var target_position = global_position

onready var anim_player = $AnimationPlayer

func update_target_position():
	var target_vector = Vector2(rand_range(-32, 32), rand_range(-32, 32))
	target_position = start_position + target_vector

func is_at_target_position(): 
	# Stop moving when at target +/- tolerance
	return (target_position - global_position).length() <= TOLERANCE

func _physics_process(delta):
	anim_player.play("flying")
	
	match state:
		IDLE:
			if wait_timer.time_left == 0:
				wait_timer.start()

		WANDER:
			accelerate_to_point(target_position, ACCELERATION * delta)

			if is_at_target_position():
				state = IDLE
		HUNT:
			accelerate_to_point(player.global_position, ACCELERATION * delta)
		
	velocity = move_and_slide(velocity)

func accelerate_to_point(point, acceleration_scalar):
	var direction = (point - global_position).normalized()
	var acceleration_vector = direction * acceleration_scalar
	accelerate(acceleration_vector)

func accelerate(acceleration_vector):
	velocity += acceleration_vector
	velocity = velocity.clamped(MAX_SPEED)

func _on_Area2D_body_entered(body):
	if body is Player:
		state = HUNT
		player = body


func _on_RoamTimer_timeout():
	update_target_position()
	state = WANDER
