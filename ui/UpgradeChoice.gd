extends TextureButton

signal upgrade_chosen(upgrade)

onready var sprite = $Sprite
onready var text = $VBoxContainer/Text
onready var title = $VBoxContainer/Title
onready var anim := $AnimationPlayer
var mouse_present = false
var upgrade = State.Upgrade.Lamp

func wiggle():
	anim.play("wiggle")

func mouse_entered():
	wiggle()
	mouse_present = true

func mouse_exited():
	anim.stop(true)
	anim.play("RESET")
	mouse_present = false

func upgraded():
	emit_signal("upgrade_chosen", upgrade)

func _ready():
	sprite.texture = State.upgrade_icon(upgrade)
	text.text = State.upgrade_text(upgrade)
	title.text = State.upgrade_title(upgrade)
	var _ignore = self.connect("mouse_entered", self, "mouse_entered")
	_ignore = self.connect("mouse_exited", self, "mouse_exited")
	_ignore = self.connect("pressed", self, "upgraded")

func init(upgrade_):
	upgrade = upgrade_
