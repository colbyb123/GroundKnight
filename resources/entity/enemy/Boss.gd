extends "res://resources/entity/EntityBase.gd"

export(PackedScene) var DAGGER: PackedScene = preload("res://resources/projectiles/EnemyArrow.tscn")

var phase = 1

var point 
onready var pos1 = get_parent().get_node("Position2D")
onready var pos2 = get_parent().get_node("Position2D2")

onready var player = get_parent().get_node("Player")
onready var timer = $Timer

var velocity = Vector2.ZERO
const MAX_SPEED = 300
const ACCELERATION = 300
const TOLERANCE = 25

func _ready():
	point = pos1.global_position

func _physics_process(delta):
	$AnimationPlayer.play("flying")
	
	var diff = global_position.x - player.global_position.x
	if diff > 0:
		$Sprite.scale.x = -1.5
	elif diff < 0:
		$Sprite.scale.x = 1.5
		
	if Global.damage == 34:
		defense = 29
	elif Global.damage == 50:
		defense = 43
	
	if phase == 1:
		accelerate_to_point(point, ACCELERATION * delta)
		if is_at_target_position() and point == pos1.global_position:
			point = pos2.global_position
		if is_at_target_position() and point == pos2.global_position:
			point = pos1.global_position
	
	move_and_slide(velocity)
	
func is_at_target_position(): 
	return (point - global_position).length() < TOLERANCE

func accelerate_to_point(point, acceleration_scalar):
	var direction = (point - global_position).normalized()
	var acceleration_vector = direction * acceleration_scalar
	accelerate(acceleration_vector)

func accelerate(acceleration_vector):
	velocity += acceleration_vector
	velocity = velocity.clamped(MAX_SPEED)

func shoot():
	var dagger_direction = self.global_position.direction_to(player.global_position)
	throw_dagger(dagger_direction)
	$AudioStreamPlayer.play()
		
func throw_dagger(dagger_direction: Vector2):
	if DAGGER:
		var dagger = DAGGER.instance()
		get_tree().current_scene.add_child(dagger)
		dagger.global_position = self.global_position
		var dagger_rotation = dagger_direction.angle()
		dagger.rotation = dagger_rotation
		
		timer.start()


func _on_Timer_timeout():
	shoot()
