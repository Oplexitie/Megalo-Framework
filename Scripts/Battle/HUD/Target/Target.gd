extends Sprite

var state: = 0
var choiceDir: = 0.0

var currEnemy: = 0
var enemyDef: = 0.0
var enemyStrikePos: = Vector2()

onready var strike: = preload("res://Scenes/Battle/HUD/Target/Strike/Strike.tscn")

signal playerAttack(Who, TakeDamage, DamageTime)
signal playerMiss

func _ready() -> void:
	var choicePos: = randi() % 2
	$Choice.position.x = -290 if choicePos == 0 else 290
	choiceDir = 0 if choicePos == 0 else 2


func _input(event: InputEvent) -> void:
	if state == 0 and event.is_action_pressed("ui_accept"):
		state = 1
		$Choice.playing = true
		
		var damage: float = ((global.wepStrength + global.at) - enemyDef) + randf() * 2
		
		var myX = $Choice.global_position.x
		var myPerfectX = global_position.x
		
		var bonusFactor = abs(myX - myPerfectX)
		if bonusFactor == 0: bonusFactor = 1
		
		var stretch: float = (texture.get_width() - bonusFactor) / texture.get_width()
		
		if bonusFactor <= 12: damage = round(damage * 2.2)
		if bonusFactor > 12: damage = round((damage * stretch) * 2)
		
		var s = strike.instance()
		s.position = enemyStrikePos - Vector2(5,5)
		s.stretch = stretch

		get_parent().add_child(s)
		
		emit_signal("playerAttack", currEnemy, damage, s.damageTimer)


func _process(delta: float) -> void:
	if ($Choice.position.x > 290 and choiceDir == 0) or ($Choice.position.x < -290 and choiceDir == 2):
		state = 2
		if $Choice.visible: emit_signal("playerMiss")
	
	match state:
		0: $Choice.position.x += cos(deg2rad(choiceDir * 90)) * delta * 360
		2:
			$Choice.hide()
			modulate.a -= 0.08 * (delta * 30)
			scale.x -= 0.06 * (delta * 30)
