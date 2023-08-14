extends Node2D

var Nugget = preload("res://ui/HealthbarNugget.tscn")

onready var nuggetbox = $NuggetBox

func set_health(amount):
	var count = nuggetbox.get_child_count()
	if amount == count:
		print("Maybe bug: asked to set health to its current value??")
	elif amount < count:
		var children = []
		for i in range(count - amount):
			children.append(nuggetbox.get_child(i))
		for child in children:
			child.queue_free()
	else:
		for _i in range(amount - count):
			var nugget = Nugget.instance()
			nuggetbox.add_child(nugget)