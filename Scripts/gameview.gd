extends Viewport

onready var borders = [$"../../../../Border/Hallborder", $"../../../../Border/Hallborder2"]
onready var scenes = [
	load("res://Scenes/Battle/Battle.tscn"),
	load("res://Scenes/GameOver/GameOver.tscn"),
	load("res://Scenes/Menu/menu.tscn")
	]
onready var anim = $"../../../../Border/AnimationPlayer"
var curscene

func _ready():
	curscene = scenes[2].instance()
	add_child(curscene)

func loadScene(goingto):
	#deletes the old scene before switching to the new one
	curscene.queue_free()
	curscene = scenes[goingto].instance()
	add_child(curscene)

func changeborder(newbg,speed):
	#switeches between border 1 and 2 to do the fade effect
	if (borders[0].z_index == 1):
		borders[1].frame = newbg
		anim.playback_speed = speed
		anim.play("fade1")
	elif (borders[1].z_index == 1):
		borders[0].frame = newbg
		anim.playback_speed = speed
		anim.play("fade2")
