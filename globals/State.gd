extends Node2D

signal player_died()
signal health_set(amount)

const MAX_HEALTH = 12
var player_health = MAX_HEALTH - 2
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

enum UPGRADE { Lamp, Meatballs, Fire }

var IconLamp = preload("res://Aseprite/lamp1.png")
var IconMeatballs = preload("res://Aseprite/meatballs.png")
var IconFire = preload("res://Aseprite/fire1.png")

func available_upgrades():
	return [ UPGRADE.Lamp, UPGRADE.Meatballs, UPGRADE.Fire ]

func upgrade_icon(upgrade):
	match upgrade:
		UPGRADE.Lamp:
			return IconLamp
		UPGRADE.Meatballs:
			return IconMeatballs
		UPGRADE.Fire:
			return IconFire

func upgrade_title(upgrade):
	match upgrade:
		UPGRADE.Lamp:
			return "OBEGRÄNSAD"
		UPGRADE.Meatballs:
			return "SWEDISH MEATBALLS"
		UPGRADE.Fire:
			return "PULL THE FIRE ALARM"

func upgrade_text(upgrade):
	match upgrade:
		UPGRADE.Lamp:
			return "see a little more around you"
		UPGRADE.Meatballs:
			return "3 meatballs. vegetarian."
		UPGRADE.Fire:
			return "turns on every 10 seconds"

func apply_upgrade(upgrade):
	match upgrade:
		UPGRADE.Lamp:
			pass
		UPGRADE.Meatballs:
			increase_health(3)
		UPGRADE.Fire:
			pass