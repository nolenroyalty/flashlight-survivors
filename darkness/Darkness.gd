extends Node2D

func _process(_delta):
	var relative_pos = Lights.player_circle.pos / get_viewport().get_size()
	var light_radius = Lights.player_circle.radius
	$Sprite.material.set_shader_param("player_pos", relative_pos)
	$Sprite.material.set_shader_param("player_light_radius", light_radius)
	$Sprite.material.set_shader_param("flashlight_direction", Lights.flashlight_direction)
	# make_image()

	pass
