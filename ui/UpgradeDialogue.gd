extends CanvasLayer

signal finished()

onready var choice_holder = $Background/ChoiceHolder
onready var congrats = $Background/CongratsLabel
onready var audio = $Audio

var UpgradeChoice = preload("res://ui/UpgradeChoice.tscn")
var rng : RandomNumberGenerator

func on_upgrade_chosen(upgrade):
	State.apply_upgrade(upgrade)
	emit_signal("finished")

func _ready():
	audio.play()
	$AnimationPlayer.play("shwoop")
	congrats.text = "Reached level %d!" % [State.player_level]

	rng = RandomNumberGenerator.new()
	rng.randomize()
	var all_choices = State.available_upgrades()
	var my_choices = []

	for _i in range(min(len(all_choices), 3 - len(my_choices))):
		var choice = rng.randi_range(0, len(all_choices)-1)
		my_choices.append(all_choices[choice])
		all_choices.remove(choice)

	if len(my_choices) < 3:
		my_choices.append(State.Upgrade.BigTote)
	
	for choice in my_choices:
		var choice_node = UpgradeChoice.instance()
		choice_node.init(choice)
		choice_holder.add_child(choice_node)
		choice_node.connect("upgrade_chosen", self, "on_upgrade_chosen")
