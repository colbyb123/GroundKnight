extends "res://resources/entity/EntityBase.gd"
class_name Player

export(PackedScene) var DAGGER: PackedScene = preload("res://resources/projectiles/PlayerDagger.tscn")

signal grounded_update(is_grounded)

onready var attackTimer1 = $AttackTimer1
onready var attackLength1 = $AttackLength1
onready var attackTimer2 = $AttackTimer2

onready var attackBar = $ProgressBar
onready var attackBox = $Sprite/ColorRect

onready var dashBar = $ProgressBar2

onready var anim_player = $AnimationPlayer
var sprite_scale : int

var velocity : Vector2
export var max_speed : int = 350
export var gravity : float = 45
export var jump_force : int = 750
export var acceleration : int = 50

var jump_count = 0
var jump_max = 1
var wall_jump = false

var is_grounded

onready var dash_timer = $Dash_Timer
onready var dash_cooldown = $Dash_Cooldown
var unlocked_dash = false
var can_dash = true
var dashing = false
var dashDir = Vector2.ZERO

onready var hitbox = $Sprite/Hitbox/CollisionShape2D

func _ready():
	get_node("Sprite/Hitbox").damage = Global.damage
	jump_max = Global.jump_max
	position.x = Global.player_x
	position.y = Global.player_y
	hp = Global.health
	unlocked_dash = Global.dash
	wall_jump = Global.wall_jump
	
	sprite_scale = sprite.scale.x

func dash():
	if Input.is_action_just_pressed("dash") and can_dash and unlocked_dash:
		dash_timer.start()
		can_dash = false
		dashing = true
		velocity = dashDir.normalized() * 10000

func _physics_process(delta):
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_update", is_grounded)
	
	if attackTimer1.time_left != 0:
		attackBar.visible = true
		attackBar.value = attackTimer1.time_left 
	elif attackTimer1.time_left == 0:
		attackBar.visible = false
	
	if dash_cooldown.time_left != 0:
		dashBar.visible = true
		dashBar.value = dash_cooldown.time_left
	elif dash_cooldown.time_left == 0:
		dashBar.visible = false
	
	if abs(velocity.x) > 10:
		anim_player.play('run')

	if abs(velocity.x) < 10:
		anim_player.play('idle')
	
	if is_on_floor():
		jump_count = 0
	if is_on_wall() and wall_jump:
		jump_count = 0
	
	if not is_on_floor():
		velocity.y += gravity
		if velocity.y > 2000:
			velocity.y = 2000
		

	if Input.is_action_pressed("right"):
		$AnimatedSprite.scale.y = 0.14
		$AnimatedSprite.position.x = 24
		sprite.scale.x = 2.5
		velocity.x += acceleration 
		dashDir = Vector2(1,0)

	elif Input.is_action_pressed("left"):
		$AnimatedSprite.scale.y = -0.14
		$AnimatedSprite.position.x = -24
		sprite.scale.x = -2.5
		velocity.x -= acceleration
		dashDir = Vector2(-1,0)

	else:
		velocity.x = lerp(velocity.x,0,0.2)
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = -jump_force
	
	if Input.is_action_just_pressed("up") and jump_count < jump_max:
		velocity.y = -jump_force * 1.2
		jump_count += 1
	
	if Input.is_action_just_released("up"):
		if velocity.y < 0:
			velocity.y += 400
	
	"""
	if Input.is_action_pressed("down"):
		if sprite.scale.x > 0:
			sprite.rotation_degrees = 90
		elif sprite.scale.x < 0:
			sprite.rotation_degrees = -90
	elif Input.is_action_pressed("up"):
		if sprite.scale.x > 0:
			sprite.rotation_degrees = -90
		elif sprite.scale.x < 0:
			sprite.rotation_degrees = 90
	
	if Input.is_action_just_released("down") or Input.is_action_just_released("up"):
		sprite.rotation_degrees = 0
	"""
	
	dash()
	
	if Input.is_action_just_pressed("attack_1") and attackTimer1.is_stopped():
		$AnimatedSprite.play("default")
		hitbox.disabled = false
		attackLength1.start()
		attackTimer1.start()
	
	if Input.is_action_just_pressed("attack_2") and attackTimer2.is_stopped():
		$DaggerSound.play()
		var dagger_direction = self.global_position.direction_to(get_global_mouse_position())
		throw_dagger(dagger_direction)
		
	velocity = move_and_slide(velocity, Vector2.UP)
	

func throw_dagger(dagger_direction: Vector2):
	if DAGGER:
		var dagger = DAGGER.instance()
		get_tree().current_scene.add_child(dagger)
		dagger.global_position = self.global_position
		
		var dagger_rotation = dagger_direction.angle()
		dagger.rotation = dagger_rotation
		
		attackTimer2.start()

func _on_Dash_Timer_timeout():
	dashing = false
	
	max_speed = 500
	acceleration = 50
	
	dash_cooldown.start()


func _on_Dash_Cooldown_timeout():
	can_dash = true

func reset(x,y):
	position.x = x
	position.y = y


func _on_AttackLength1_timeout():
	hitbox.disabled = true
	attackBox.visible = false

func set_jump_count(value):
	jump_max = value
	Global.jump_max = value

func set_wall_jump(value):
	wall_jump = value
	Global.wall_jump = value

func inc_damage():
	get_node("Sprite/Hitbox").damage = 50
	Global.damage = 50

func unlock_dash():
	unlocked_dash = true
	Global.dash = true

func die():
	Global.reset()
	get_tree().change_scene("res://resources/menus/DeathScreen.tscn")



func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "default":
		$AnimatedSprite.play("idle")
