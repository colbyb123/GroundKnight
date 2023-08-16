extends Camera2D

const AHEAD_FACTOR = 0.2
const SHIFT = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 1.0

onready var pre_pos = get_camera_position()
onready var tween = $ShiftTween

var facing = 0

func _process(delta):
	_check_facing()
	pre_pos = get_camera_position()
	

func _check_facing():
	var new_facing = sign(get_camera_position().x - pre_pos.x)
	if new_facing != 0 && facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * facing * AHEAD_FACTOR
		tween.interpolate_property(self, "position:x", position.x,  target_offset, SHIFT_DURATION, SHIFT, SHIFT_EASE)

func _on_Player_grounded_update(is_grounded):
	drag_margin_v_enabled = !is_grounded
