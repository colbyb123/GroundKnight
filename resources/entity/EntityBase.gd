extends KinematicBody2D

signal hp_max_changed(new_hp_max)
signal hp_changed(new_hp)
signal died

const INDICATOR_DAMAGE = preload("res://resources/UI/DamageIndicator.tscn")


export(int) var hp_max: int = 100 setget set_hp_max
export(int) var hp: int = hp_max setget set_hp, get_hp
export(int) var defense: int = 0

export(bool) var receives_knockback: bool = true
export(float) var knockback_modifier: float = 0.1


export(PackedScene) var EFFECT_HIT: PackedScene = null
export(PackedScene) var EFFECT_DIED: PackedScene = null

onready var sprite = $Sprite
onready var collShape = $CollisionShape2D

onready var hurtbox = $Hurtbox
onready var healthBar = $EntityHealthbar


func get_hp():
	return hp

func set_hp(value):
	if value != hp:
		hp = clamp(value, 0, hp_max)
		emit_signal("hp_changed", hp)
#		healthBar.value = hp
		healthBar.animate_hp_change(hp)
		if hp == 0:
			emit_signal("died")
		elif hp != hp_max:
			healthBar.show()

func set_hp_max(value):
	if value != hp_max:
		hp_max = max(0, value)
		emit_signal("hp_max_changed", hp_max)
		self.hp = hp


func die():
	spawn_effect(EFFECT_DIED)
	queue_free()

func receive_damage(base_damage: int):
	var actual_damage = base_damage
	actual_damage -= defense
	
	self.hp -= actual_damage
	return actual_damage

func receive_knockback(damage_source_pos: Vector2, received_damage: int):
	if receives_knockback:
		var knockback_direction = damage_source_pos.direction_to(self.global_position)
		var knockback_strength = (received_damage / 2) * knockback_modifier
		var knockback = knockback_direction * knockback_strength
		
		global_position += knockback


func _on_Hurtbox_area_entered(hitbox):
	if $InvinTimer.time_left == 0:
		$InvinTimer.start()
		var actual_damage = receive_damage(hitbox.damage)
		receive_knockback(hitbox.global_position, actual_damage)
		spawn_effect(EFFECT_HIT)
		spawn_dmgIndicator(actual_damage)
	
	if hitbox.is_in_group("Projectile"):
		hitbox.destroy()
	


func _on_EntityBase_died():
	die()

func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect

func spawn_dmgIndicator(damage: int):
	var indicator = spawn_effect(INDICATOR_DAMAGE)
	if indicator:
		indicator.label.text = str(damage)

func inc_health(value):
	set_hp(hp + value)

