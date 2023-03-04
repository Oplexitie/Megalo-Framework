extends Node

var border
var playerHeart
var bullets

signal endAttack


func _ready() -> void:
	playerHeart.changeMode(2)
	
	for n in 5: bullets.createPlatform(0, Vector2(513 + (n * 220), 345), 120, 2, 120)
	for n in 4: bullets.createPlatform(0, Vector2(70 - (n * 280), 305), 160, 0, 120)
	
	for n in 16:
		var Jump = randi() % 3
		match Jump:
			0: bullets.createBone(0, Vector2(515, 255), 45, 2, 120)
			1: bullets.createBone(0, Vector2(124, 305), 40, 0, 120)
			2: bullets.createBone(0, Vector2(515, 350), 35, 2, 120)
		$"../../Attacks/Timer".start(0.5)
		yield($"../../Attacks/Timer", "timeout")
	
	emit_signal("endAttack")
