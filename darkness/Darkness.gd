extends Node2D

func _process(_delta):
	var viewport_size = U.to_shader_coords(get_viewport().get_size())

	$Sprite.material.set_shader_param("player", Lights.player.to_vec3(viewport_size))

	var idx = 1
	for vec in Lights.get_all_lights(viewport_size):
		var name = "fixed%s" % idx
		# var vec = light.to_vec3(viewport_size)
		
		$Sprite.material.set_shader_param(name, vec)
		idx += 1

	$Sprite.material.set_shader_param("flashlight_direction", Lights.flashlight_direction)
	
	if Input.is_action_pressed("debug_flash_light"):
		$Sprite.material.set_shader_param("max_darkness", 0.75)
	else:
		$Sprite.material.set_shader_param("max_darkness", 1.0)
