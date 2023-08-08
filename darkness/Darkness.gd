extends Node2D

func _process(_delta):
	var viewport_size = get_viewport().get_size()

	$Sprite.material.set_shader_param("player", Lights.player.to_vec3(viewport_size))

	var idx = 1
	for light in Lights.all_lights():
		var name = "fixed%s" % idx
		var vec = light.to_vec3(viewport_size)
		
		$Sprite.material.set_shader_param(name, vec)
		idx += 1

	$Sprite.material.set_shader_param("flashlight_direction", Lights.flashlight_direction)
	
	if Input.is_action_pressed("debug_flash_light"):
		$Sprite.material.set_shader_param("max_darkness", 0.75)
	else:
		$Sprite.material.set_shader_param("max_darkness", 1.0)
