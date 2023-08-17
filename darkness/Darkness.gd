extends Node2D

func _ready():
	$Sprite.material.set_shader_param("light_cone_angle", Lights.light_cone_angle)
	var _ignore = Lights.connect("alarm_flash_set", self, "handle_alarm_flash")

var max_darkness = 1.0 setget set_max_darkness

# we have a setter to make it easy to tween
func set_max_darkness(val):
	max_darkness = val
	$Sprite.material.set_shader_param("max_darkness", val)

func handle_alarm_flash(alarm_on):
	# We should also make this red
	if alarm_on:
		var t = get_tree().create_tween()
		t.tween_property(self, "max_darkness", 0.75, 0.2)
		t.set_ease(Tween.EASE_IN_OUT)
		# $Sprite.material.set_shader_param("max_darkness", 0.75)
	else:
		var t = get_tree().create_tween()
		t.set_ease(Tween.EASE_IN_OUT)
		t.tween_property(self, "max_darkness", 1.0, 0.2)
		# set_max_darkness(1.0)
		# $Sprite.material.set_shader_param("max_darkness", 1.0)


func _process(_delta):
	var viewport_size = U.to_shader_coords(get_viewport().get_size())
	$Sprite.material.set_shader_param("player", Lights.player.to_vec3(viewport_size))
	
	var idx = 1
	for vec in Lights.get_all_lights(viewport_size):
		var name = "fixed%s" % idx
		$Sprite.material.set_shader_param(name, vec)
		idx += 1

	$Sprite.material.set_shader_param("flashlight_direction", Lights.flashlight_direction)
	
	if Input.is_action_pressed("debug_flash_light"):
		$Sprite.material.set_shader_param("max_darkness", 0.75)
		#$Sprite.material.set_shader_param("color_mix", Color("#8e3a47"))
	elif Input.is_action_just_released("debug_flash_light"):
		$Sprite.material.set_shader_param("max_darkness", 1.0)
		#$Sprite.material.set_shader_param("color_mix", Color(0, 0, 0, 1))