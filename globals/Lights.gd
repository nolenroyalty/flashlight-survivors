extends Node2D

var circles := {}
var _idx := 0
var flashlight_direction := Vector2(0, 0)

class Circle:
	var pos = Vector2()
	var radius = 0.0

	func init(pos_, radius_):
		pos = pos_
		radius = radius_

var player_circle = Circle.new()

func register_circle(pos, radius):
	var circle = Circle.new()
	circle.init(pos, radius)
	circles[_idx] = circle
	_idx += 1
	return _idx - 1

func update_circle(idx, pos, radius):
	circles[idx].pos = pos
	circles[idx].radius = radius

func deregister_circle(idx):
	circles.erase(idx)

func all_circles():
	return circles.values()