extends Node

var border
var playerHeart
var bullets

signal endAttack

func _ready() -> void:
	playerHeart.changeMode(2)

	$"../../Attacks/Timer".start(0.2)
	yield($"../../Attacks/Timer", "timeout")
	for n in 8:
		bullets.createBone(0, Vector2(128 - (n * 120), border.margin_top + 5), 95, 0, 180,1)
		bullets.createBone(0, Vector2(128 - (n * 120), border.margin_bottom - 20 - 5), 20, 0, 180,1)
		bullets.createBone(0, Vector2(503 + (n * 120), border.margin_top + 5), 95, 2, 180,1)
		bullets.createBone(0, Vector2(503 + (n * 120), border.margin_bottom - 20 - 5), 20, 2, 180,1)
	
	$"../../Attacks/Timer".start(6.4)
	yield($"../../Attacks/Timer", "timeout")
	emit_signal("endAttack")
