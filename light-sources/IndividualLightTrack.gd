extends LightSource

const FADE_IN = 1.0
const FADE_OUT = 1.0
const LIFETIME = 2.0
const MOVE_DISTANCE = 100

var current_radius = 0 setget set_current_radius
var max_radius : int
var vector : Vector2
var idx = 0
var move_mult

func init(base_pos, move_mult_, idx_, vector_, max_radius_):
	max_radius = max_radius_
	vector = vector_
	idx = idx_
	move_mult = move_mult_
	position = base_pos + idx * vector * max_radius * 2.0

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
	tween.tween_property(self, "current_radius", max_radius, FADE_IN)

	var tangent = vector.tangent()
	var mult = move_mult
	if idx % 2 == 0:
		mult *= -1
	tween.tween_property(self, "position", position + tangent * mult * MOVE_DISTANCE, LIFETIME / 4)
	tween.tween_property(self, "position", position + tangent * mult * -1 * MOVE_DISTANCE, LIFETIME / 2)
	tween.tween_property(self, "position", position, LIFETIME / 4)

	tween.tween_property(self, "current_radius", 0, FADE_OUT)
	tween.tween_callback(self, "call_deferred", ["queue_free"])
