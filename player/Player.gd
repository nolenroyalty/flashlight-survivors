extends KinematicBody2D

signal health_set(amount)

export (int)var SPEED = 100
var health = 10
var myidx = 2;
var invincible = false
var iframe_duration = 0.6

# Need to prevent moving outside of the screen!
func _physics_process(_delta):
	var dx = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	var dy = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	var dir = Vector2(dx, dy).normalized()
	var speed = SPEED + 10 * State.speed_level
	var _unused_velocity = move_and_slide(dir * speed)
#	position += dir * SPEED * delta
	Lights.player.pos = position
	set_flashlight_direction()

func set_flashlight_direction():
	var pos = get_viewport().get_mouse_position()
	var dir = position.direction_to(pos)
	look_at(pos)
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
		t.tween_property(self, "modulate", Color("#696969"), iframe_duration / 2.0)
		t.tween_property(self, "modulate", Color("#ffffff"), iframe_duration / 2.0)
		t.tween_property(self, "invincible", false, 0.0)
		print("ow")
		# add iframes
		health -= amount
		health = max(health, 0)
		emit_signal("health_set", health)
		if health <= 0:
			print("oh noooo")

func _process(_delta):
	if Input.is_action_just_pressed("debug_emit_fixed_light"):
		Lights.add_fixed_light(position, 35.0)

func _ready():
	Lights.player.pos = position
	set_flashlight_direction()