extends CanvasLayer

var Name = ["Sans"]
var actOptions = [["Check"],["Inspect"]]
var actChoiceText: Array = [
	[ # Enemy 1
		# Choice 1
		[
			["* SANS 1 ATK 1 DEF\n* The easiest enemy.\n  Can only deal 1 damage.", 1.0, {}, {}],
		],
		# Choice 2
		[
			["* You inspected Sans...", 1.0, {}, {}],
			["* .....What?", 10.0, {7 : 1.0}, {7 : 1.0}],
		],
	],
	[ # Enemy 2
		
	]
]
var enemymaxhp = 300
var enemyhealth = enemymaxhp

var timerBonus: = 0.0

#Values used for dodging
var dodgeSpeed: = 0.0

#Values used for the shaking when hit
var enemy_shake = 20
var step_hit = 0
var audio_play = false
var waitstrike = 0

#Values used for both dodging and being hitting 
var damagestate = 0
var dualpos = 0
var dualtimer = 0

onready var enemyStrikePos: Array
onready var damageWriter: = preload("res://Scenes/Battle/Enemy/DamageWriter/DamageWriter.tscn")
onready var borderbox = $"../BorderLayer/Border"
onready var character = $Sans
onready var charaspeech = $Dialogue
onready var charaattack = $"../Attacks"

func _process(delta: float) -> void:
	enemyStrikePos = [character.position - Vector2(5, 5)]
	character.position.y = borderbox.ideal[1] - 130
	
	match damagestate:
		1:
			character.position.x += dodgeSpeed * (delta * 30)
			
			if character.position.x < dualpos - 60 and dualtimer < 20:
				if dodgeSpeed < 0: dodgeSpeed = dodgeSpeed + 2 * delta * 30
				else: dodgeSpeed = 0
			
			dualtimer += 1 * (delta * 30)	
			
			if dualtimer >= 20 + timerBonus:
				if dodgeSpeed < 12: dodgeSpeed = dodgeSpeed + 2 * delta * 30
				if character.position.x >= (dualpos - (1.0 / 30.0)):
					damagestate = 0
					dodgeSpeed = 0
					character.position.x = dualpos
					
					for n in get_tree().get_nodes_in_group("DamageWriter"): n.destroy(15)
					for n in get_tree().get_nodes_in_group("Target"): n.state = 2
					
					charaspeech.runDialogue(charaattack.attack)
					charaattack.runAttack()
		2:
			match step_hit:
				0:
					yield(get_tree().create_timer(waitstrike / 30.0), "timeout")
					step_hit = 1
				1:
					if (audio_play == false):
						audio.playsfx(6, preload("res://Audio/Sounds/Hit.wav"))
						audio_play = true
						
					if floor(dualtimer) == 0:
						if (enemy_shake < 0):
							enemy_shake = - enemy_shake - 2
						else:
							enemy_shake = - enemy_shake
						
						character.position.x = dualpos + clamp(enemy_shake, -8, 8)
						dualtimer = 2.5
						
						if (enemy_shake == 0):
							yield(get_tree().create_timer(20 / 30.0), "timeout")
							step_hit = 2
					else:
						dualtimer = max(dualtimer - (30 * delta), 0)
				2:
					character.position.x = dualpos
					damagestate = 0
					
					for n in get_tree().get_nodes_in_group("DamageWriter"): n.destroy(15)
					for n in get_tree().get_nodes_in_group("Target"): n.state = 2
					
					charaspeech.runDialogue(charaattack.attack)
					charaattack.runAttack()



func playerAttack(Who, TakeDamage, DamageTime):
	charaattack.attack += 1
	
	match Who:
		0:
			timerBonus = DamageTime
			
			#If you want the monster to dodge set damagestate=1
			#Altough if you want the monster to take a hit set damagestate=2
			#damagestate=0 means nothing's happening
			damagestate = 2
			dodgeSpeed = -12

			step_hit = 0
			audio_play = false
			enemy_shake = 20
			
			dualpos = character.position.x
			dualtimer = 0
			waitstrike = DamageTime
			
			yield(get_tree().create_timer(DamageTime / 30.0), "timeout")
			
			if (damagestate == 2):
				createDamageWriter(Vector2(270, 75), 114, 100)
			else:
				createDamageWriter(Vector2(270, 75), 114, 0)


func createDamageWriter(Position, Width, DamageTaken, DestroyTime: = -1.0):
	var i = damageWriter.instance()
	i.position = Position - Vector2(9,0)
	
	i.damageTaken = DamageTaken
	i.enemyhealth = enemyhealth
	i.enemymaxhp = enemymaxhp
	
	enemyhealth -=DamageTaken
	
	add_child(i)
	if DestroyTime > -1: i.destroy(DestroyTime)
	
	return i
