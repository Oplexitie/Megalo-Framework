extends Camera2D

var intensity = 0
var shakeTimer = 0


func _process(delta: float) -> void:
	if intensity > 0: shakeTimer += 30 * delta
	else: offset = Vector2.ZERO
	if shakeTimer >= 1.0:
		shakeTimer -= 1.0
		intensity -= 1
		offset = Vector2(intensity * random.choose([1, -1]), intensity * random.choose([1, -1]))


func shake(amount): intensity = amount
