extends Node

var border
var playerHeart
var bullets

signal endAttack


func _ready() -> void:
	randomize()
	for n in 16:
		var r = randi() % 4
		$"../../Attacks/Timer".start(0.26666)
		yield($"../../Attacks/Timer", "timeout")
		
		playerHeart.slam(r)
		sans().armIndex = 0
		match r:
			0: sans().moveArm = 1
			1: sans().moveArm = 3
			2: sans().moveArm = 4
			3: sans().moveArm = 2
		
		$"../../Attacks/Timer".start(0.2)
		yield($"../../Attacks/Timer", "timeout")
		bullets.createBoneStab(0, r, 25, 9, 6)

		$"../../Attacks/Timer".start(0.43333)
		yield($"../../Attacks/Timer", "timeout")
	sans().armIndex = 0
	sans().moveArm = 0
	emit_signal("endAttack")


func sans():
	var a: = $"../../Enemy/Sans"
	if is_instance_valid(a): return a
	else: return
