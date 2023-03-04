extends Node2D

onready var gameviewport = 	$"../../Viewport"

func _ready() -> void:
	randomize()
	
	$Background/ColorRect.rect_scale = $Camera.zoom * 6
	
	#Player setup
	global.hp = global.maxHP
	$Hud/Name.text = global.playerName + "   LV " + str(global.lv)
	global.kr = 0
	global.item = [
	# Page 1
	["Pie", "Butterscotch Pie", "", 99],
	["Steak", "Face Steak", "", 60],
	["L. Hero", "Legendary Hero", "ATTACK Increased by 4!", 40],
	["L. Hero", "Legendary Hero", "ATTACK Increased by 4!", 40],
	# Page 2
	["L. Hero", "Legendary Hero", "ATTACK Increased by 4!", 40],
	["SnowPiece", "Snowman Piece", "", 45],
	["Ketchup", "Ashe Ketchup", "", 100],
	["Ketchup", "Ashe Ketchup", "", 100],
	]
	
	$HeartLayer/PlayerHeart.connect("camShake", $Camera, "shake")
	$Hud.connect("runAttack", $Attacks, "runAttack")
	$Attacks.connect("menuEnable", $Hud, "menuBattle")
	
	# Makes using the editor easier
	if !$Attacks/BackBufferCopy/Mask.visible: $Attacks/BackBufferCopy/Mask.visible = true
	$Overlay/fade.visible = true
	
	$Tween.interpolate_property($Overlay/fade, "modulate:a", 1, 0, 0.5)
	$Tween.start()
	
	yield(get_tree(), "idle_frame")

	#If you want to start with a direct attack with a bit of dialogue, Deactivate this and...
	$Hud.menuBattle()
	
	#And Activate all of these
	#$Attacks.attack = 0
	#$Enemy/Dialogue.runDialogue($Attacks.attack)
	#$Attacks.runAttack()
	#audio.play("Music/AmbientBirds", 1.0, 1.0, true)
	
	audio.play("Music/Megalovania", 1.0, 1.0, true)

# warning-ignore:unused_parameter
func _process(delta: float) -> void:
	if (global.hp) <= 0:
		audio.stop("Music/Megalovania")
		global.deathHeartPos = $HeartLayer/PlayerHeart.position
		global.deathHeratCol = $HeartLayer/PlayerHeart/Sprite.modulate
		
		gameviewport.changeborder(10,1)
		gameviewport.loadScene(1)
