extends Node

var border
var playerHeart
var bullets

signal endAttack


func _ready() -> void:
	playerHeart.changeMode(2)
	for n in 16:
		bullets.createPlatform(0, Vector2(552 + (n * 140), 346), 51, 2, 120)
		bullets.createPlatform(0, Vector2(-20 - (n * 160), 306), 51, 0, 120)
	for n in 12:
		var y = randi() % 3
		y *= 40
		y += 285
		bullets.createGasterBlaster(1, Vector2(2, 1), Vector2(0,0), Vector2(73, y), 0, 17, 3)
		$"../../Attacks/Timer".start(0.7)
		yield($"../../Attacks/Timer", "timeout")
		y = randi() % 3
		y *= 40
		y += 285
		bullets.createGasterBlaster(1, Vector2(2, 1), Vector2(640,0), Vector2(563, y), 180, 17, 3)
		$"../../Attacks/Timer".start(0.7)
		yield($"../../Attacks/Timer", "timeout")
	emit_signal("endAttack")
