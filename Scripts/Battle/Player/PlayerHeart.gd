extends KinematicBody2D

var mode: = 0

var invCount: = 0.0
var damageTimeout: = 0.0

var gravity: = 0.0
var fallSpeed: = 0.0
var maxFallSpeed: = 750.0

var slammed: = false
var slamDamage: = false
var slamFall: = Vector2()

var krTime: = 0.0
var krBonus: = 0
var prevHP: = 0

var up_direction: = Vector2(0, -1)
var motion_velocity: = Vector2()
var floor_snap: = false

signal camShake(Amount)

var moveInput = Vector2()
var speed = 150

onready var p_sprite = $Sprite
onready var p_hitbox = $HitBox

func _input(event):
	moveInput = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	speed = 150 if !Input.is_action_pressed("ui_cancel") else 75

func _physics_process(delta: float) -> void:
	match mode:
		1: heartModeRed(delta, speed, moveInput)
		2: heartModeBlue(delta, speed, moveInput)
	
	match round(rad2deg(p_sprite.rotation)):
		0.0: up_direction = Vector2.LEFT
		90.0: up_direction = Vector2.UP
		180.0: up_direction = Vector2.RIGHT
		270.0: up_direction = Vector2.DOWN
	
	damageTimeout += delta
	
	if invCount > 0:
		p_sprite.playing = true
		p_sprite.speed_scale = 0.5
		invCount = invCount - (delta * 30)
	else:
		if p_sprite.animation == "default":
			p_sprite.frame = 0
			p_sprite.playing = false
			p_sprite.speed_scale = 1
		
		invCount = 0
	
	# Collision checking/Damage.
	for areas in p_hitbox.get_overlapping_areas():
		var bullet = areas.get_owner()
		if bullet.is_in_group("Bullet"):
			if "damage" in bullet and "bulletMode" in bullet:
				if (
					bullet.bulletMode == 0
					or bullet.bulletMode == 1 and !motion_velocity.is_equal_approx(Vector2.ZERO)
					or bullet.bulletMode == 2 and motion_velocity.is_equal_approx(Vector2.ZERO)
				):
					if bullet.has_signal("playerHurt"): bullet.emit_signal("playerHurt")
					if bullet.has_method("playerHurt"): bullet.call("playerHurt")
					takeDamage(bullet.damage, bullet.karma if "karma" in bullet else 0)
			
			elif "damage" in bullet and not "bulletMode" in bullet:
				if bullet.has_signal("playerHurt"): bullet.emit_signal("playerHurt")
				if bullet.has_method("playerHurt"): bullet.call("playerHurt")
				takeDamage(bullet.damage, bullet.karma if "karma" in bullet else 0)
			
			if "karma" in bullet:
				if bullet.karma >= 2: bullet.karma = 1
				if bullet.karma >= 3: bullet.karma = 2
				if bullet.karma >= 5: bullet.karma = 3
	
	if global.kr > 40: global.kr = 40
	if global.kr >= global.hp: global.kr = global.hp - 1
	if global.kr > 0 and global.hp > 1:
		krTime += delta
		if prevHP == global.hp:
			if global.inv >= 45: krBonus = random.choose([0, 1])
			if global.inv >= 60: krBonus = random.choose([0, 1, 1])
			if global.inv >= 75: krBonus = 1
			
			if (
				krTime >= (1 + krBonus) / 30.0 and global.kr >= 40 or
				krTime >= (2 + (krBonus * 2)) / 30.0 and global.kr >= 30 or
				krTime >= (5 + (krBonus * 3)) / 30.0 and global.kr >= 20 or
				krTime >= (15 + (krBonus * 5)) / 30.0 and global.kr >= 10 or
				krTime >= (30 + (krBonus * 10)) / 30.0
			):
				krTime = 0
				global.hp -= 1
				global.kr -= 1
			if global.hp <= 0: global.hp = 1
		prevHP = global.hp


func takeDamage(HP, KR = 0):
	if damageTimeout >= 1.0 / 30.0:
		damageTimeout = 0
		if invCount == 0:
			global.hp -= HP
			if global.kr > -1: global.kr += KR
			elif HP > 0:
				emit_signal("camShake", 5)
				invCount = global.inv
			audio.play("Sounds/Player/Hurt")


func slam(direction = 1):
	changeMode(2, direction * 90)
	yield(get_tree().create_timer(get_physics_process_delta_time()), "timeout")
	slamFall = Vector2(maxFallSpeed, maxFallSpeed)
	yield(get_tree().create_timer(get_physics_process_delta_time()), "timeout")
	slammed = true


func slamDisable():
	yield(get_tree().create_timer(get_physics_process_delta_time()), "timeout")
	slammed = false


func changeMode(setMode: = 0, setDirection: = 90.0) -> void:
	match setMode:
		1: p_sprite.modulate = Color(1, 0, 0)
		2: p_sprite.modulate = Color(0, 0.25, 1)
		3: p_sprite.modulate = Color(0, 0.75, 0)
		4: p_sprite.modulate = Color(1, 1, 0)
	p_sprite.rotation = deg2rad(setDirection)
	
	motion_velocity = Vector2()
	gravity = 0
	fallSpeed = 0
	mode = setMode


func heartModeRed(_delta, speed, moveInput):
	motion_velocity = speed * moveInput
	motion_velocity = move_and_slide(motion_velocity)


func heartModeBlue(delta, speed, moveInput):
	var jumpDirection: Dictionary = {0.0 : Input.is_action_pressed("ui_left"), 90.0 : Input.is_action_pressed("ui_up"), 180.0 : Input.is_action_pressed("ui_right"), 270.0 : Input.is_action_pressed("ui_down")}
	
	var heartAngle: = round(rad2deg(p_sprite.rotation))
	
	if fallSpeed < 240.0 and fallSpeed > 15.0: gravity = 540.0
	if fallSpeed <= 15.0 and fallSpeed > -30.0: gravity = 180.0
	if fallSpeed <= -30.0 and fallSpeed > -120: gravity = 450.0
	if fallSpeed <= -120.0: gravity = 180.0
	
	if !is_on_floor():
		floor_snap = false
		if slammed: motion_velocity = Vector2(cos(p_sprite.rotation), sin(p_sprite.rotation)) * maxFallSpeed
		else: motion_velocity += Vector2(cos(p_sprite.rotation), sin(p_sprite.rotation)) * gravity * delta
	
	if heartAngle in [0.0, 180.0]: motion_velocity.y = moveInput.y * speed
	if heartAngle in [90.0, 270.0]: motion_velocity.x = moveInput.x * speed
	
	if is_on_floor():
		if heartAngle in [0.0, 180.0]: motion_velocity.x = 0
		if heartAngle in [90.0, 270.0]: motion_velocity.y = 0
		
		if jumpDirection[heartAngle]:
			floor_snap = false
			motion_velocity -= Vector2(cos(p_sprite.rotation), sin(p_sprite.rotation)) * 180.0
		
		if slammed:
			if abs(slamFall.x) >= 330.0: emit_signal("camShake", floor(abs(slamFall.x / 30.0 / 3.0)))
			if abs(slamFall.y) >= 330.0: emit_signal("camShake", floor(abs(slamFall.y / 30.0 / 3.0)))
			takeDamage(int(slamDamage))
			audio.play("Sounds/Impact")
			slamDisable()
	else:
		match heartAngle:
			0.0:
				motion_velocity.x = min(maxFallSpeed, motion_velocity.x)
				fallSpeed = motion_velocity.x
				if !jumpDirection[heartAngle] and motion_velocity.x < -30.0: motion_velocity.x = -30.0
			90.0:
				motion_velocity.y = min(maxFallSpeed, motion_velocity.y)
				fallSpeed = motion_velocity.y
				if !jumpDirection[heartAngle] and motion_velocity.y < -30.0: motion_velocity.y = -30.0
			180.0:
				motion_velocity.x = max(-maxFallSpeed, motion_velocity.x)
				fallSpeed = -motion_velocity.x
				if !jumpDirection[heartAngle] and motion_velocity.x > 30.0: motion_velocity.x = 30.0
			270.0:
				motion_velocity.y = max(-maxFallSpeed, motion_velocity.y)
				fallSpeed = -motion_velocity.y
				if !jumpDirection[heartAngle] and motion_velocity.y > 30.0: motion_velocity.y = 30.0
	
	var snapVector = up_direction * -32 if floor_snap else Vector2()
	motion_velocity = move_and_slide_with_snap(motion_velocity, snapVector, up_direction, 48.0)
	
	var justLanded = is_on_floor() and not floor_snap
	if justLanded: floor_snap = true

