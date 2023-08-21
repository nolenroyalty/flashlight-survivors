extends Node2D

var death_audios = []
var death_idx = 0
var explode_audios = []
var explode_idx = 0

func play_death():
	death_audios[death_idx].play()
	death_idx = (death_idx + 1) % len(death_audios)

func play_explode():
	explode_audios[explode_idx].play()
	explode_idx = (explode_idx + 1) % len(explode_audios)

func stop_all():
	for audio in death_audios:
		audio.stop()
	for audio in explode_audios:
		audio.stop()

func _ready():
	for child in $DeathAudios.get_children():
		death_audios.append(child)
	for child in $ExplodeAudios.get_children():
		explode_audios.append(child)
