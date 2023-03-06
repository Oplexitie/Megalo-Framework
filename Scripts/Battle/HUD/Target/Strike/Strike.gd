extends AnimatedSprite

var damageTimer: = 0.0
var stretch: = 0.0


func _ready() -> void:
	speed_scale = 0.5 - (stretch / 4.0)
	scale = Vector2((stretch * 2) - 0.5, (stretch * 2) - 0.5)
	
	position.x -= (scale.x - 1.0) * (frames.get_frame(animation, frame).get_width() / 2.0)
	position.y -= (scale.y - 1.0) * (frames.get_frame(animation, frame).get_height() / 2.0)
	
	audio.play(3, preload("res://Audio/Sounds/Player/Strike.wav"))
	if speed_scale == 0: speed_scale = 0.1
	
	damageTimer = ((1.0 / speed_scale) * frames.get_frame_count(animation)) + 3
	playing = true


func _on_Strike_animation_finished() -> void: queue_free()
