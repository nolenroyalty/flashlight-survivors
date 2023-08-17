extends KinematicBody2D

export (int)var SPEED = 100
var myidx = 2;
var invincible = false
var iframe_duration = 1.25

# Need to prevent moving outside of the screen!
func _physics_process(_delta):
	var dx = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	var dy = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	var dir = Vector2(dx, dy).normalized()
	var speed = SPEED * (1.0 + 0.2 * State.speed_level)
	var _unused_velocity = move_and_slide(dir * speed)
	$Playerproto.flip_h = dx < 0.0
	Lights.player.pos = position
	set_flashlight_direction()

func set_flashlight_direction():
	var pos = get_viewport().get_mouse_position()
	var dir = position.direction_to(pos)
	#dir.angle()
	$Cone.look_at(pos)
	$LightLamp.look_at(pos)
	$Flashlight.rotation_degrees = rad2deg(dir.angle())
	if dir != Lights.flashlight_direction:
		Lights.flashlight_direction = dir
	Lights.flashlight_direction = dir

func set_not_invincible():
	invincible = false

func damage(amount):
	if invincible:
		return
	else:
		invincible = true
		var t = get_tree().create_tween()
		var duration = iframe_duration / 2.0
		t.tween_property(self, "modulate:a", 0.1, 1.5 * duration)
		t.set_ease(Tween.EASE_OUT)
		t.set_trans(Tween.TRANS_QUAD)
		t.tween_property(self, "modulate:a", 1.0, 0.5 * duration)
		t.tween_property(self, "invincible", false, 0.0)
		State.decrease_health(amount)
		
func _process(_delta):
	if Input.is_action_just_pressed("debug_emit_fixed_light"):
		Lights.add_fixed_light(position, 35.0)

func _ready():
	Lights.player.pos = position
	set_flashlight_direction()
