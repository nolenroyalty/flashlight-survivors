extends Node2D

func v(x, y):
	return Vector2(x, y)

func to_shader_coords(vector):
	return vector / 2