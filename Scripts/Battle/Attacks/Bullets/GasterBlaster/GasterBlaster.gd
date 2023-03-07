extends Node2D

var ID: = 0.0
var con: = 1

var angle: = 90.0

var ideal: = Vector2(200, 200)
var idealRot: = 90.0

var indexTimer: = 0.0
var sFixTimer: = 0.0
var sprFrame: = 0.0

var skip: = true
var pause: = 8

var bt: = 0.0
var btimer: = 0.0
var fade: = 1.0

var terminal: = 10

var bb: = 0.0
var bbsiner: = 0.0

var speed: = 0.0

var damage: = 1
var karma: = 10

var bulletMode: = 0.0

var camera


func _ready() -> void: randomize()


func _process(delta: float) -> void:
	rotation = deg2rad(angle)
	
	if con == 1 and !skip:
		position.x += floor((ideal.x - position.x) / 3.0) * (delta * 30)
		position.y += floor((ideal.y - position.y) / 3.0) * (delta * 30)
		
		if position.x < ideal.x: position.x += 1 * (delta * 30)
		if position.y < ideal.y: position.y += 1 * (delta * 30)
		if position.x > ideal.x: position.x -= 1 * (delta * 30)
		if position.y > ideal.y: position.y -= 1 * (delta * 30)
		
		if abs(position.x - ideal.x) < 3.0: position.x = ideal.x
		if abs(position.y - ideal.y) < 3.0: position.y = ideal.y
		
		if abs(position.x - ideal.x) < 0.1 and abs(position.y - ideal.y) < 0.1:
			con = 2
			alarm(2)
	if con == 1 and skip:
		position.x += floor((ideal.x - position.x) / 3.0) * (delta * 30)
		position.y += floor((ideal.y - position.y) / 3.0) * (delta * 30)
		
		if position.x < ideal.x: position.x += 1 * (delta * 30)
		if position.y < ideal.y: position.y += 1 * (delta * 30)
		if position.x > ideal.x: position.x -= 1 * (delta * 30)
		if position.y > ideal.y: position.y -= 1 * (delta * 30)
		
		if abs(position.x - ideal.x) < 3.0: position.x = ideal.x
		if abs(position.y - ideal.y) < 3.0: position.y = ideal.y
		
		angle += floor((idealRot - angle) / 3.0) * (delta * 30)
		
		if angle < idealRot: angle += 1 * (delta * 30)
		if angle > idealRot: angle -= 1 * (delta * 30)
		
		if abs(angle - idealRot) < 3.0: angle = idealRot
		
		if abs(position.x - ideal.x) < 0.1 and abs(position.y - ideal.y) < 0.1 and abs(idealRot - angle) < 0.01:
			con = 4
			alarm(pause)
	if con == 3:
		angle += floor((idealRot - angle) / 3.0)
		
		if angle < idealRot: angle += 1 * (delta * 30)
		if angle > idealRot: angle -= 1 * (delta * 30)
		
		if abs(angle - idealRot) < 3.0: angle = idealRot
		
		if abs(idealRot - angle) < 0.01:
			con = 4
			alarm(pause)
	if con == 5:
		con = 6
		alarm(4)
	if con == 6:
		sprFrame += 1 * (delta * 30)
		$Sprite.frame = floor(sprFrame)
	if con == 7:
		indexTimer += delta
		if indexTimer >= 1.0 / 30.0:
			indexTimer = 0
			if $Sprite.frame <= 3: $Sprite.frame = 4
			if $Sprite.frame == 4: $Sprite.frame = 5
			elif $Sprite.frame == 5: $Sprite.frame = 4
		
		if btimer == 0:
			audio.playsfx(4, preload("res://Audio/Sounds/Bullets/GasterBlast.wav"), 1.2)
			
			if camera.has_method("shake"): if $Sprite.scale.y >= 2: camera.shake(5)
		
		position -= Vector2(cos(rotation), sin(rotation)) * speed * (delta * 30)

		btimer += 1 * (delta * 30)
		
		if btimer < 5:
			speed += 1 * (delta * 30)
			bt = min(bt + floor((35.0 * $Sprite.scale.y) / 4.0) * (delta * 30), 35.0 * $Sprite.scale.y)
		else: speed += 4 * (delta * 30)
		
		if btimer > (5 + terminal):
			sFixTimer += delta
			if sFixTimer >= 1.0 / 30.0:
				sFixTimer = 0
				bt *= 0.8
			
			fade -= 0.1 * (delta * 30)
			if bt <= 2: queue_free()
		
		if !$Sprite/OnScreen.is_on_screen(): speed = 0
		
		bbsiner += 1 * (delta * 30)
		bb = (sin(bbsiner / 1.5) * bt) / 4.0
		
		var rr = (randf() * 2) - (randf() * 2)
		var rr2 = (randf() * 2) - (randf() * 2)
		
		$Laser.visible = true
		$Laser.rect_size = Vector2(1000, bt + bb)
		$Laser.rect_position = Vector2((70 * ($Sprite.scale.y / 2.0)) + rr, (-$Laser.rect_size.y / 2.0) + rr2)
		$Laser.modulate.a = fade
		
		$LaserTop.visible = true
		$LaserTop.rect_size = Vector2(12.5, (bt / 2.0) + bb)
		$LaserTop.rect_position = Vector2((50 * ($Sprite.scale.y / 2.0)) + rr, (-$LaserTop.rect_size.y / 2.0) + rr2)
		$LaserTop.modulate.a = fade
		
		$LaserTop2.visible = true
		$LaserTop2.rect_size = Vector2(15, (bt / 1.25) + bb)
		$LaserTop2.rect_position = Vector2((60 * ($Sprite.scale.y / 2.0)) + rr, (-$LaserTop2.rect_size.y / 2.0) + rr2)
		$LaserTop2.modulate.a = fade
		
		#$LaserHitBox.visible = true
		$LaserHitBox.rect_size = Vector2(1000, (bt * 3.0) / 4.0)
		$LaserHitBox.rect_position = Vector2((70 * ($Sprite.scale.y / 2.0)) + rr, (-$LaserHitBox.rect_size.y / 2.0) + rr2)
		$LaserHitBox.modulate.a = fade
		
		$HitBox.visible = true
		$HitBox/Collision.position = $LaserHitBox.rect_position + ($LaserHitBox.rect_size / 2.0)
		$HitBox/Collision.shape.extents = $LaserHitBox.rect_size / 2.0
		$HitBox.modulate.a = fade
		$HitBox/Collision.disabled = fade < 0.8


func alarm(time):
	#yield(get_tree().create_timer(time / 30.0), "timeout")
	$Timer.start(time / 30.0)
	yield($Timer, "timeout")
	con += 1 
