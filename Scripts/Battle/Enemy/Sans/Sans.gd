extends Node2D

var bounce: = 1
var siner: = 0.0

var offset: = Vector2()
var headOffset: = Vector2(0, 0)

var deadTest: = 0

var moveArm: = 0
var armIndex: = 0.0
var armSpeed: = 1.0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	match bounce:
		3:
			siner += 1 * (delta * 30)
			offset.y = sin(siner / 18) * 2
		2:
			siner += 1 * (delta * 30)
			offset.y = sin(siner / 15) * 4
		1:
			siner += 1 * (delta * 30)
			offset = Vector2(cos(siner / 6), sin(siner / 3))
		0:
			siner = 0
			offset = Vector2(0, 0)
	
	if deadTest == 0:
		$Torso.position = Vector2(offset.x, 42 + (offset.y / 1.5))
		$Head.position = offset + headOffset
		
		if moveArm > 0:
			$Body.visible = true
			$Torso.visible = false
		else:
			$Body.visible = false
			$Torso.visible = true
			armIndex = 0
			headOffset = Vector2(0, 0)
		
		if moveArm == 1:
			$Body.offset = -Vector2(33, 12)
			
			if armIndex >= 11: armIndex = 11
			
			$Body.animation = "HandRight"
			$Body.frame = floor(armIndex / 2.0)
			
			headOffset.y = 0
			if floor(armIndex) == 2: headOffset.x = -4
			if floor(armIndex) == 4: headOffset.x = -8
			if floor(armIndex) == 6: headOffset.x = 10
			if floor(armIndex) == 8: headOffset.x = 4
			if floor(armIndex) < 11: armIndex += 1 * (delta * 30)
			else: armIndex = 11
		if moveArm == 2:
			if $Body.offset in [1, 2, 4, 5]: -Vector2(29, 34)
			else: $Body.offset = -Vector2(30, 34)
			
			if armIndex >= 11: armIndex = 11
			
			$Body.animation = "HandUp"
			$Body.frame = floor(armIndex / 2.0)
			
			headOffset.x = 0
			if floor(armIndex) == 0: headOffset.y = 4
			if floor(armIndex) == 2: headOffset.y = 10
			if floor(armIndex) == 4: headOffset.y = 4
			if floor(armIndex) == 6: headOffset.y = -4
			if floor(armIndex) == 8: headOffset.y = 0
			if floor(armIndex) < 11: armIndex += 1 * (delta * 30)
			else: armIndex = 11
		if moveArm == 3:
			$Body.offset = -Vector2(30, 34)
			
			if armIndex >= 9: armIndex = 9
			
			$Body.animation = "HandDown"
			$Body.frame = floor(armIndex / 2.0)
			
			headOffset.x = 0
			if floor(armIndex) == 0: headOffset.y = 0
			if floor(armIndex) == 2: headOffset.y = 0
			if floor(armIndex) == 4: headOffset.y = 6
			if floor(armIndex) == 6: headOffset.y = 10
			if floor(armIndex) < 9: armIndex += 1 * (delta * 30)
			else: armIndex = 9
		if moveArm == 4:
			$Body.offset = -Vector2(33, 12)
			
			if armIndex >= 10: armIndex = 10
			
			$Body.animation = "HandRight"
			$Body.frame = floor(5 - (armIndex / 2.0))
			
			headOffset.y = 0
			if floor(armIndex) >= 10: headOffset.x = 0
			if floor(armIndex) == 8: headOffset.x = -4
			if floor(armIndex) == 6: headOffset.x = -8
			if floor(armIndex) == 4: headOffset.x = 10
			if floor(armIndex) == 2: headOffset.x = 4
			if floor(armIndex) < 10: armIndex += 1 * (delta * 30)
			else: armIndex = 10
