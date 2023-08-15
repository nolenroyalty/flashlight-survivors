extends TextureButton

onready var sprite = $Sprite
onready var anim := $AnimationPlayer
var mouse_present = false

func wiggle():
	anim.play("wiggle")

func mouse_entered():
	wiggle()
	mouse_present = true

func mouse_exited():
	anim.stop(true)
	anim.play("RESET")
	mouse_present = false

func _ready():
	var _ignore = self.connect("mouse_entered", self, "mouse_entered")
	_ignore = self.connect("mouse_exited", self, "mouse_exited")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
