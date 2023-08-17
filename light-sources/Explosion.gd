extends LightSource

onready var anim = $AnimationPlayer

func animation_finished(name):
	if name == "kaboom":
		call_deferred("queue_free")

func damage_if_present(body):
	print("EXPLODE AT %s" % body)
	.damage_if_present(body)

var pos = null
func init(pos_):
	pos = pos_

func _ready():
	damage_on_first_tick = true
	damage_per_tick = 2.0
	seconds_per_tick = null
	anim.play("kaboom")
	anim.connect("animation_finished", self, "animation_finished")