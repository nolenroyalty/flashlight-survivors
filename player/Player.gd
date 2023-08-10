extends Node2D

export (int)var SPEED = 100

var myidx = 2;
var light_radius = 0.075;

# Need to prevent moving outside of the screen!
func _physics_process(delta):
	var dx = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	var dy = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	var dir = Vector2(dx, dy).normalized()
	position += dir * SPEED * delta
	Lights.player.pos = position
	set_flashlight_direction()

func set_flashlight_direction():
	var pos = get_viewport().get_mouse_position()
	var dir = position.direction_to(pos)
	look_at(pos)
	# var angle = position.angle_to(pos)
	# if angle != rotation:
		# print(angle)
		# rotation = angle
	if dir != Lights.flashlight_direction:
		Lights.flashlight_direction = dir
	Lights.flashlight_direction = dir

func _process(_delta):
	if Input.is_action_just_pressed("debug_emit_fixed_light"):
		Lights.add_fixed_light(position, light_radius * 2.0)

func _ready():
	Lights.player.pos = position
	Lights.player.radius = light_radius
	set_flashlight_direction()
