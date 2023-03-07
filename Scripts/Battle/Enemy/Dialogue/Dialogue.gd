extends Node2D


onready var speechBubble: Dictionary = {
	"Sans" : [preload("res://Scenes/Battle/Enemy/Dialogue/SpeechBubbles/SansBubble.tscn"), preload("res://Audio/Sounds/Voice/Sans.wav")]
}


func createSpeechBubble(Child, SpeechBubble, Position, Text, TextSpeed, SetSpeed, SetPause, Interactable: = true, DestroyTime: = 0.0):
	var i = speechBubble[SpeechBubble][0].instance()
	var t = i.get_node("RPGText")
	
	i.position = Position
	
	t.bbcode_text = Text
	
	t.textSound = speechBubble[SpeechBubble][1]
	t.speed = TextSpeed
	t.setSpeed = SetSpeed
	t.setPause = SetPause
	
	t.interactable = Interactable
	t.destroyTime = DestroyTime
	
	
	Child.add_child(i)
	
	return [i, t]


func runDialogue(Num):
	var text = []
	
	match Num:
		0:
			text = [
				["it's a beautiful day outside.", 2.0, {}, {}, true, 0.0],
				["birds are singing, flowers are blooming...", 2.0, {}, {}, true, 0.0],
				["on days like these, kids like you...", 2.0, {}, {}, true, 0.0],
				["Should be burning in hell.", 5.0, {}, {}, true, 0.0],
			]
		1:
			#If you want to change the text color do "[color=red]*inset text*[/color]"
			#If you want to make the text shake do "[shake rate=20 level=20]*inset text*[/shake]"
			text = [
				["did you actually [shake rate=20 level=20]try[/shake]to stab me?", 1.0, {}, {16:1}, true, 0.0],
				["try harder, [shake rate=20 level=10][color=red]noob.[/color][/shake]", 7.0, {}, {}, true, 0.0],
			]
	
	if len(text) > 0:
		for n in len(text):
			var bubble: = "Sans"
			var target: = $"../Sans"
			var newPosition: = Vector2(60, 0)
			
			#This is for each sentence in a dialogue
			match Num:
				#Change the n°1 to the dialogue this applies to
				0: match n:
					0:
						$"../Sans/Head".animation = "ClosedEyes"
						$"../Sans/Torso".animation = "Default"
					3:
						$"../Sans/Head".animation = "NoEyes"
						$"../Sans/Torso".animation = "Default"
				1: match n:
					0:
						$"../Sans/Head".animation = "Tired"
						$"../Sans/Torso".animation = "Shrug"
					1:
						$"../Sans/Head".animation = "NoEyes"
						$"../Sans/Torso".animation = "Default"
			
			var b = createSpeechBubble(target, bubble, newPosition, text[n][0], text[n][1], text[n][2], text[n][3], text[n][4], text[n][5])
			yield(b[1], "con")
	$"../../Attacks".emit_signal("startAttack")
	$"../../BorderLayer/Border".emit_signal("resizeFinished")
	
	
	#$"../Sans/Head".animation = "Default"
	#$"../Sans/Torso".animation = "Default"
