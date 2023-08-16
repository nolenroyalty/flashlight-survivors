extends Node2D

signal player_died()
signal health_set(amount)
signal lamp_increased(level)
signal alarm_enabled()

const MAX_HEALTH = 10
var player_health = MAX_HEALTH
var player_level = 1

func decrease_health(amount):
	player_health -= amount
	if player_health <= 0:
		player_health = 0
		emit_signal("player_died")
	emit_signal("health_set", player_health)

func increase_health(amount):
	player_health += amount
	player_health = min(player_health, MAX_HEALTH)
	emit_signal("health_set", player_health)

enum Upgrade { Lamp, Meatballs, Fire, TrackLighting, Explode, Speed, Drunkenness, BigTote }

var IconLamp = preload("res://Aseprite/lamp1.png")
var IconMeatballs = preload("res://Aseprite/meatballs.png")
var IconFire = preload("res://Aseprite/fire1.png")
var IconTrack = preload("res://Aseprite/tracklighting1.png")
var IconExplode = preload("res://Aseprite/battery.png")
var IconSpeed = preload("res://Aseprite/grease.png")
var IconDrunk = preload("res://Aseprite/booze.png")
var IconTote = preload("res://Aseprite/booze.png")


var lamp_level = 0
var max_lamp_level = 4
var beam_width_level = 0
var max_beam_width_level = 3
var fire_alarm_level = 0
var max_fire_alarm_level = 6
var track_lighting_level = 0
var max_track_lighting_level = 4
var explode_level = 0
var max_explode_level = 3
var speed_level = 0
var max_speed_level = 6
var drunkenness_level = 0
var max_drunkenness_level = 2
var number_of_big_totes = 0

func current_level(upgrade):
	match upgrade:
		Upgrade.Lamp:
			return lamp_level
		Upgrade.Meatballs:
			return 0
		Upgrade.Fire:
			return fire_alarm_level
		Upgrade.TrackLighting:
			return track_lighting_level
		Upgrade.Explode:
			return explode_level
		Upgrade.Speed:
			return speed_level
		Upgrade.Drunkenness:
			return drunkenness_level
		Upgrade.BigTote:
			return number_of_big_totes

func max_level(upgrade):
	match upgrade:
		Upgrade.Lamp:
			return max_lamp_level
		Upgrade.Meatballs:
			return null
		Upgrade.Fire:
			return max_fire_alarm_level
		Upgrade.TrackLighting:
			return max_track_lighting_level
		Upgrade.Explode:
			return max_explode_level
		Upgrade.Speed:
			return max_speed_level
		Upgrade.Drunkenness:
			return max_drunkenness_level
		Upgrade.BigTote:
			return null

func available(upgrade):
	var cur = current_level(upgrade)
	var max_ = max_level(upgrade)
	if max_ == null: 
		match upgrade:
			Upgrade.Meatballs:
				return player_health < State.MAX_HEALTH - 1
		return true
	return cur < max_


func available_upgrades():
	var l = []
	for upgrade in Upgrade.values():
		if upgrade == Upgrade.BigTote:
			continue
		if available(upgrade):
			l.append(upgrade)
	return l

func upgrade_icon(upgrade):
	match upgrade:
		Upgrade.Lamp:
			return IconLamp
		Upgrade.Meatballs:
			return IconMeatballs
		Upgrade.Fire:
			return IconFire
		Upgrade.TrackLighting:
			return IconTrack
		Upgrade.Explode:
			return IconExplode
		Upgrade.Speed:
			return IconSpeed
		Upgrade.Drunkenness:
			return IconDrunk
		Upgrade.BigTote:
			return IconTote
		

func upgrade_title(upgrade):
	match upgrade:
		Upgrade.Lamp:
			match lamp_level:
				0: return "NÄVLINGE"
				1: return "HÅRSLINGA"
				2: return "SOMMARLÅNKE"
				3: return "OBEGRÄNSAD"
		Upgrade.Meatballs:
			return "SWEDISH MEATBALLS"
		Upgrade.Fire:
			if fire_alarm_level == 0:
				return "PULL THE FIRE ALARM"
			else:
				return "PULLING MORE MAKES IT GO FASTER?"
		Upgrade.TrackLighting:
			match track_lighting_level:
				0: return "TROSS"
				1: return "NYMÅNE"
				2: return "STRATOSFÄR"
				3: return "HAUNTED STRATOSFÄR"
		Upgrade.Explode:
			match explode_level:
				0: return "LADDA"
				1: return "MANY LADDA"
				2: return "STENKOL LADDA"
		Upgrade.Speed:
			if speed_level == 0: return "GREASY WHEELS"
			else: return "GREASIER WHEELS"
		Upgrade.Drunkenness:
			match drunkenness_level:
				0: return "TIPSY ASSEMBLY"
				1: return "DRUNKEN ASSEMBLY"
		Upgrade.BigTote:
			return "BIG TOTE"
		
	return "BUG NO TITLE SORRY"

func upgrade_text(upgrade):
	match upgrade:
		Upgrade.Lamp:
			match lamp_level:
				0: return "see a little more around you"
				1: return "see a little more around you"
				2: return "see a lot more around you"
				3: return "slowly damage enemies that are close by"
		Upgrade.Meatballs:
			return "3 meatballs. vegetarian."
		Upgrade.Fire:
			if fire_alarm_level == 0:
				return "alarm flashes every 6 seconds"
			else:
				return "alarm flashes more frequently"
		Upgrade.TrackLighting:
			match track_lighting_level:
				0: return "3 spotlights to zap your foes"
				1: return "another spotlight means more zapping"
				2: return "another spotlight means more zapping"
				3: return "spotlights move around"
		Upgrade.Explode:
			match explode_level:
				0: return "powerful batteries occasionally cause explosions"
				1: return "more powerful batteries mean more explosions"
				2: return "big batter pack. bigger explosions."
		Upgrade.Speed:
			if speed_level == 0:
				return "grease up your cart wheels to travel faster"
			else:
				return "more grease. more speed."
		Upgrade.Drunkenness:
			match drunkenness_level:
				0: return "doors occasionally fall apart when hit with light"
				1: return "doors often fall apart when hit with light"
		Upgrade.BigTote:
			return "it's iconic"
	
	return "BUG NO TEXT SORRY"

func apply_upgrade(upgrade):
	match upgrade:
		Upgrade.Lamp:
			lamp_level += 1
			lamp_level = min(lamp_level, max_lamp_level)
			emit_signal("lamp_increased", lamp_level)
		Upgrade.Meatballs:
			increase_health(3)
		Upgrade.Fire:
			fire_alarm_level += 1
			if fire_alarm_level == 1:
				emit_signal("alarm_enabled")
			fire_alarm_level = min(fire_alarm_level, max_fire_alarm_level)
		Upgrade.TrackLighting:
			track_lighting_level += 1
			track_lighting_level = min(track_lighting_level, max_track_lighting_level)
		Upgrade.Explode:
			explode_level += 1
			explode_level = min(explode_level, max_explode_level)
		Upgrade.Speed:
			speed_level += 1
			speed_level = min(speed_level, max_speed_level)
		Upgrade.Drunkenness:
			drunkenness_level += 1
			drunkenness_level = min(drunkenness_level, max_drunkenness_level)
		Upgrade.BigTote:
			number_of_big_totes += 1
