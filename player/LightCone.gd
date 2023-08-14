extends LightSource

# I think our actual angle is PI / 6 and this is halved
# in each direction in the shader?
var angle = PI / 12

func _ready():
	seconds_per_tick = 0.5
	damage_per_tick = 1.0
	Lights.light_cone_angle = angle
