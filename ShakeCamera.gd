extends Camera2D

#https://kidscancode.org/godot_recipes/3.x/2d/screen_shake/index.html

export var decay = 0.9  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(500, 500)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.0  # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.

onready var noise = OpenSimplexNoise.new()
var noise_y = 0
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	current = true

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
	
func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

func reset():
	offset = Vector2()
	rotation = 0.0
	trauma = 0.0

func _process(delta):
	if target:
		global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()