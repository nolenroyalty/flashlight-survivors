extends LightSource

onready var anim = $AnimationPlayer

func animation_finished(name):
	if name == "kaboom":
		call_deferred("queue_free")

func _ready():
	damage_on_first_tick = true
	damage_per_tick = 2.0
	seconds_per_tick = null
	anim.play("kaboom")
	anim.connect("animation_finished", self, "animation_finished")
	