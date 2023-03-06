extends RichTextLabel

var ID: = 0
var textName: = ""

var type: = 0

var typerTimer: = 0.0
var charCount: = 1
var speed: = 1.0
var pauseTimeout: = 0.0

var setSpeed: = {}
var setPause: = {}

var interactable: = true
var destroyTime: = 0.0

var textSound

signal con


func _ready() -> void: visible_characters = 0


func _input(event: InputEvent) -> void:
	if interactable:
		if charCount < len(text) and event.is_action_pressed("ui_cancel"): charCount = len(text)
		if charCount == len(text) and event.is_action_pressed("ui_accept"):
			if get_parent().is_in_group("ParentDestroyable"): get_parent().queue_free()
			else: queue_free()
			emit_signal("con")


func _process(delta: float) -> void:
	visible_characters = charCount
	
	if charCount < len(text):
		if pauseTimeout == 0:
			typerTimer += delta
			if charCount in setSpeed.keys() and !setSpeed.empty(): speed = setSpeed[charCount]
			
			if typerTimer >= speed / 30.0:
				typerTimer -= speed / 30.0
				if type == 0: blitNormal()
				
		elif pauseTimeout > 0: pauseTimeout = pauseTimeout - min(delta, pauseTimeout)
		else: pauseTimeout = 0
	else:
		typerTimer = 0
		charCount = len(text)
	
	if !interactable:
		if destroyTime > 0: destroyTime = destroyTime - min(delta, destroyTime)
		else:
			if get_parent().is_in_group("ParentDestroyable"): get_parent().queue_free()
			else: queue_free()
			emit_signal("con")


func blitNormal(): # Default blitting type
	charCount += 1
	
	if charCount in setPause.keys() and !setPause.empty(): pauseTimeout = setPause[charCount]
	
	# Not play the blitting sound if the current charCount is a space
	if (charCount < len(text) - 1):
		match text[charCount]:
			" ", "?", ".", "!", ",": return
			_: audio.play(1,textSound)
