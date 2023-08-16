extends "res://resources/entity/EntityBase.gd"

export(PackedScene) var DAGGER: PackedScene = preload("res://resources/projectiles/EnemyArrow.tscn")

enum {
	IDLE,
	HUNT
}

var state = IDLE
var player = null
var not_playing = true
onready var timer = $Timer
onready var anim_player = $AnimationPlayer

func _physics_process(delta):
	
	if player and player.global_position.x > global_position.x:
		$Sprite.scale.x = -1.5
	elif player and player.global_position.x < global_position.x:
		$Sprite.scale.x = 1.5
	
	match state:
		IDLE:
			anim_player.play("flying")
		HUNT:
			shoot()
		
	

func shoot():
	if !timer.is_stopped():
		anim_player.play("flying")
	if timer.is_stopped():
		anim_player.play("shooting")
		
	if $Sprite.frame == 7 and timer.is_stopped():
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

func _on_Area2D_body_entered(body):
	if body is Player:
		state = HUNT
		player = body



func _on_Area2D_body_exited(body):
	if body is Player:
		state = IDLE
		player = body

