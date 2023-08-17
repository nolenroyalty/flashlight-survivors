extends LightSource

const FADE_IN = 1.0
const FADE_OUT = 1.0
const LIFETIME = 2.0
const MAX_RADIUS = 55
const MOVE_DISTANCE = 100

var current_radius = 0 setget set_current_radius
var move = false
var vector : Vector2
var idx = 0

func init(base_pos, idx_, vector_, move_):
	vector = vector_
	idx = idx_
	position = base_pos + idx * vector * MAX_RADIUS * 2.0
	move = move_

func set_current_radius(value):
	current_radius = value
	Lights.set_light(self, idx)
	$CollisionShape2D.shape.radius = value

func _ready():
	damage_on_first_tick = true
	seconds_per_tick = 1.0
	damage_per_tick = 1.0

	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "current_radius", MAX_RADIUS, FADE_IN)

	if move:
		var tangent = vector.tangent()
		var mult = 1
		if idx % 2 == 0:
			mult = -1
		tween.tween_property(self, "position", position + tangent * mult * MOVE_DISTANCE, LIFETIME / 4)
		tween.tween_property(self, "position", position + tangent * mult * -1 * MOVE_DISTANCE, LIFETIME / 2)
		tween.tween_property(self, "position", position, LIFETIME / 4)
	else:
		tween.tween_interval(LIFETIME)
	
	tween.tween_property(self, "current_radius", 0, FADE_OUT)
	tween.tween_callback(self, "call_deferred", ["queue_free"])
