extends NinePatchRect

var ID: = 0.0

var damage: = 1

#put karma to -1, if you want to take normal damage, it's better to put everything at -1 and not just some things
var karma: = 6

var speed: = 0.0
var direction: = 0.0

var bulletMode: = 0.0


func _process(delta: float) -> void:
	match bulletMode:
		0.0: modulate = Color(1, 1, 1)
		1.0: modulate = Color(0.0784, 0.6627, 1)
		2.0: modulate = Color(1, 0.6274, 0.2509)
	
	rect_position += Vector2(cos(deg2rad(direction * 90)), sin(deg2rad(direction * 90))) * delta * speed
	
	$HitBox/Collision.position = rect_size / 2.0
	$HitBox/Collision.shape.extents = rect_size / 2.0
	
	if direction == 0 and rect_position.x > 640: queue_free()
	if direction == 1 and rect_position.y > 480: queue_free()
	if direction == 2 and rect_position.x < -rect_size.x: queue_free()
	if direction == 3 and rect_position.y < -rect_size.y: queue_free()
