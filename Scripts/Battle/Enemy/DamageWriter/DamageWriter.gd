extends Node2D

var damageTaken: = 0.0
var enemymaxhp = 0
var enemyhealth = 0

func _ready() -> void:	
	if damageTaken == 0:
		$Health.visible = false
		$Text.bbcode_text = "[center]MISS"
		$Text.modulate = Color(0.752941, 0.752941, 0.752941)
	else:
		$Health.visible = true
		$Text.bbcode_text = "[center]" + str(damageTaken if damageTaken > 0 else 0)
		$Text.modulate = Color(1, 0, 0)
		
		$Health.rect_size.x = floor($Health/Background.rect_size.x * enemyhealth / enemymaxhp)
		$Tween.interpolate_property($Health, "rect_size:x", floor($Health/Background.rect_size.x * enemyhealth / enemymaxhp), floor($Health/Background.rect_size.x * (enemyhealth - damageTaken) / enemymaxhp), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		
	$Tween.interpolate_property($Text, "rect_position:y", -38, -58, 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property($Text, "rect_position:y", -58, -38, 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN, 0.3)
	$Tween.start()


func destroy(time):
	yield(get_tree().create_timer(time / 30.0), "timeout")
	queue_free()
