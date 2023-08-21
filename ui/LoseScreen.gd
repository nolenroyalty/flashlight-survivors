extends CanvasLayer

signal loaded()
signal restart()

onready var button = $Bottom/Button
onready var anim = $AnimationPlayer

func send_restart():
	print("sending restart?")
	# get_tree().paused = false
	emit_signal("restart")
	self.call_deferred("queue_free")
	

func handle_restart():
	print("restarting?")
	button.disabled = true
	var t1 = get_tree().create_tween()
	var t2 = get_tree().create_tween()
	t1.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	t2.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	t1.tween_property($Top, "modulate:a", 0.0, 0.5)
	t2.tween_property($Bottom, "modulate:a", 0.0, 0.5)
	t1.tween_callback(self, "send_restart")
	print("here")

func on_animation_finished(name):
	if name == "scroll-in":
		print("loaded")
		emit_signal("loaded")

func _ready():
	var text = "Reached level %s\nSurvived %s seconds\nFound %s iconic totes" % \
		[State.player_level, State.survival_time(), State.number_of_big_totes]
	$Bottom/ScoreLabel.text = text

	$Audio.play()
	anim.connect("animation_finished", self, "on_animation_finished")
	anim.play("scroll-in")
	button.connect("pressed", self, "handle_restart")
