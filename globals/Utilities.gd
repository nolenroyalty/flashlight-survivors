extends Node2D

var player : KinematicBody2D
var xpbar : Node2D

func v(x, y):
	return Vector2(x, y)

func to_shader_coords(vector):
	return vector / 3