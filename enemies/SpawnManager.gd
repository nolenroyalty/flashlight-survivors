extends Node2D

var Doorway = preload("res://enemies/Doorway.tscn")

var can_spawn_a_door_here = {}
var rng : RandomNumberGenerator

func door_despawned(point):
	can_spawn_a_door_here[point] = true

func spawn_door():
	var choices = []
	for point in can_spawn_a_door_here.keys():
		if can_spawn_a_door_here[point]:
			choices.append(point)
	
	if len(choices) == 0:
		return false
	
	var chosen_point = choices[rng.randi() % len(choices)]
	can_spawn_a_door_here[chosen_point] = false
	var door = Doorway.instance()
	door.position = chosen_point
	door.connect("despawned", self, "door_despawned", [chosen_point])
	add_child(door)
	return true

func _process(_delta):
	if Input.is_action_just_pressed("debug_spawn_door"):
		# We should avoid overlapping doors
		if spawn_door():
			print("door spawned")
		else:
			print("could not spawn door")

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

	for child in $DoorPoints.get_children():
		can_spawn_a_door_here[child.position] = true
