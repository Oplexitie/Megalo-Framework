extends Node2D

#Stuff related to the healthbar
onready var backg = $Background
onready var healthbar = $Health
onready var karmabar = $Karma

#Stuff next to the healthbar
onready var healthtxt = $Text
onready var karmaicn = $KRIcon

func _process(_delta: float) -> void:
	backg.rect_size.x = floor(global.maxHP * 1.2) + 1
	healthbar.rect_size.x = floor(backg.rect_size.x * global.hp / global.maxHP)
	
	# To Clickteam users: your KR bar is not accurate, fuck off.
	karmabar.rect_size.x = ceil(backg.rect_size.x * global.kr / global.maxHP)
	karmabar.rect_position.x = backg.rect_position.x + backg.rect_size.x * (global.hp - global.kr) / global.maxHP
	
	if karmabar.margin_left < backg.margin_left: karmabar.margin_left = backg.margin_left
	
	karmaicn.visible = !(global.kr <= -1)
	karmaicn.position.x = backg.margin_right + 5
	
	healthtxt.rect_position.x = backg.margin_right + 15 if global.kr <= -1 else backg.margin_right + 50

	healthtxt.bbcode_text = str(global.hp).pad_zeros(len(str(global.maxHP))) + " / " + str(global.maxHP)
	healthtxt.modulate = karmabar.color if global.kr > 0 else Color(1, 1, 1)
