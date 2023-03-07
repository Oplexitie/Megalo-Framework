extends NinePatchRect

var ID: = 0.0

var size: = 0.0
var racket: = 6.0
var con: = 0

var damage: = 1
var karma: = 6

var waitTime: = 0.0
var stayTime: = 0.0

var direction: = 0
var bulletMode: = 0.0

var idealPos: = Vector2()

onready var freePos: = rect_position


func _process(delta: float) -> void:
	match bulletMode:
		0.0: self_modulate = Color(1, 1, 1)
		1.0: self_modulate = Color(0.0784, 0.6627, 1)
		2.0: self_modulate = Color(1, 0.6274, 0.2509)
	
	$HitBox/Collision.position = rect_size / 2.0
	$HitBox/Collision.shape.extents = $HitBox/Collision.position
	
	if waitTime > 0: waitTime -= 1 * (delta * 30)
	else:
		if $Warning.visible:
			$Warning.hide(); audio.playsfx(4, preload("res://Audio/Sounds/Bullets/SpearRise.wav"))
		match con:
			0:
				rect_position -= Vector2(cos(deg2rad(direction * 90)), sin(deg2rad(direction * 90))) * floor(size / 3.0) * (delta * 30)
				if (
					rect_position.x < idealPos.x and direction == 0 or
					rect_position.y < idealPos.y and direction == 1 or
					rect_position.x > idealPos.x and direction == 2 or
					rect_position.y > idealPos.y and direction == 3
				):
					rect_position = idealPos
					con = 1
			1:
				stayTime -= 1 * (delta * 30)
				
				if racket > 0: racket -= 1 * (delta * 30)
				else: racket = 0
				
				var rr: = (randf() * racket) - (randf() * racket)
				var rr2: = (randf() * racket) - (randf() * racket)
				rect_position = Vector2(idealPos.x + rr, idealPos.y + rr2)
				
				if stayTime <= 0: con = 2
			2:
				rect_position += Vector2(cos(deg2rad(direction * 90)), sin(deg2rad(direction * 90))) * floor(size / 4.0) * (delta * 30)
				if (
					rect_position.x > freePos.x and direction == 0 or
					rect_position.y > freePos.y and direction == 1 or
					rect_position.x < freePos.x and direction == 2 or
					rect_position.y < freePos.y and direction == 3
				): queue_free()
