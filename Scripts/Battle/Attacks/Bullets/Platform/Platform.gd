extends NinePatchRect

var ID: = 0.0

var speed: = 0.0
var direction: = 0.0

var bulletMode: = 0.0


func _process(delta: float) -> void:
	match bulletMode:
		0.0:
			$Color.modulate = Color(0, 0.5, 0)
			$CollisionSlide/Collision.disabled = true
			$CollisionFollow/Collision.disabled = false
		1.0:
			$Color.modulate = Color(0.5, 0, 0.5)
			$CollisionFollow/Collision.disabled = true
			$CollisionSlide/Collision.disabled = false
	
	rect_position += Vector2(cos(deg2rad(direction * 90)), sin(deg2rad(direction * 90))) * delta * speed
	
	$Color.rect_size.x = rect_size.x
	
	$CollisionSlide/Collision.position = rect_size / 2.0
	$CollisionSlide/Collision.shape.extents = rect_size / 2.0
	
	$CollisionFollow/Collision.position = rect_size / 2.0
	$CollisionFollow/Collision.shape.extents = rect_size / 2.0
	
	if direction == 0 and rect_position.x > 640: queue_free()
	if direction == 1 and rect_position.y > 480: queue_free()
	if direction == 2 and rect_position.x < -rect_size.x: queue_free()
	if direction == 3 and rect_position.y < -rect_size.y: queue_free()
