extends Node2D

var fini_trans = false
var button_pressed = false
onready var gameviewport = 	$"../../Viewport"

func _ready():
	$Player/breakheart.position = global.deathHeartPos
	$Player/breakheart.modulate = global.deathHeratCol
	$Player/Particles2D.position = global.deathHeartPos
	$Player/Particles2D.modulate = global.deathHeratCol
	
	$Timer.start(0.5)
	yield($Timer, "timeout")
	audio.playsfx(3, preload("res://Audio/Sounds/Player/Break.wav"))
	$Player/breakheart.frame = 1
	
	$Timer.start(1)
	yield($Timer, "timeout")
	audio.playsfx(3, preload("res://Audio/Sounds/Player/Break2.wav"))
	$Player/Particles2D.emitting = true
	$Player/breakheart.queue_free()
	
	$Timer.start(1.5)
	yield($Timer, "timeout")
	audio.playmusic(load("res://Audio/Music/mus_gameover.ogg"))
	
	$Tween.interpolate_property($BlackVoid/ColorRect, "color:a", 1, 0, 1.5)
	$Tween.start()
	$Timer.start(0.5)
	yield($Timer, "timeout")
	fini_trans = true


func _input(event):
	if (fini_trans == true):
		if (Input.is_action_pressed("ui_accept") && button_pressed == false):
			button_pressed = true
			$Tween.interpolate_property($BlackVoid/ColorRect, "color:a", $BlackVoid/ColorRect.color.a, 1, 1.5)
			$Tween.start()
			
			$Timer.start(1.7)
			yield($Timer, "timeout")
			
			audio.bus_muting(3,false)
			audio.stop(0)
			gameviewport.changeborder(8,1)
			gameviewport.loadScene(0)
