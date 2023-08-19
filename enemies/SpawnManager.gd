extends Node2D

var Doorway = preload("res://enemies/Doorway.tscn")
var Puddle = preload("res://enemies/PuddleGuy.tscn")

var can_spawn_a_door_here = {}
var can_spawn_a_puddle_here = {}
var rng : RandomNumberGenerator
onready var timer = $Timer

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

func puddle_despawned(point):
	can_spawn_a_puddle_here[point] = true

func spawn_puddle():
	var choices = []
	for point in can_spawn_a_puddle_here.keys():
		if can_spawn_a_puddle_here[point]:
			choices.append(point)
	
	if len(choices) == 0:
		return false
	
	var chosen_point = choices[rng.randi() % len(choices)]
	can_spawn_a_puddle_here[chosen_point] = false
	var puddle = Puddle.instance()
	puddle.position = chosen_point
	puddle.connect("despawned", self, "puddle_despawned", [chosen_point])
	add_child(puddle)
	return true


func door_spawn_chance_increment():
	if State.player_level < 5: return 0.05
	elif State.player_level < 15: return 0.1
	else: return 0.15

var current_door_spawn_chance = .8
func maybe_spawn():
	current_door_spawn_chance += door_spawn_chance_increment()
	print(current_door_spawn_chance)
	if rng.randf() < current_door_spawn_chance:
		if spawn_door():
			current_door_spawn_chance = 0.1
		else:
			current_door_spawn_chance = 0.5


func _process(_delta):
	if Input.is_action_just_pressed("debug_spawn_door"):
		if spawn_door():
			print("door spawned")
		else:
			print("could not spawn door")
	if Input.is_action_just_pressed("debug_spawn_puddle"):
		if spawn_puddle():
			print("puddle spawned")
		else:
			print("could not spawn puddle")

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

	for child in $DoorPoints.get_children():
		can_spawn_a_door_here[child.position] = true
	
	for child in $PuddlePoints.get_children():
		can_spawn_a_puddle_here[child.position] = true

	timer.connect("timeout", self, "maybe_spawn")
