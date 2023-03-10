extends Viewport

onready var borders = [$"../../../../Border/Hallborder", $"../../../../Border/Hallborder2"]
onready var scenes = [
	"res://Scenes/Battle/Battle.tscn",
	"res://Scenes/GameOver/GameOver.tscn",
	"res://Scenes/Menu/menu.tscn"
	]
onready var anim = $"../../../../Border/AnimationPlayer"
var curscene

func _ready():
	curscene = load(scenes[2]).instance()
	add_child(curscene)

#This is to change scenes
func loadScene(goingto: int):
	#deletes the old scene before switching to the new one
	curscene.queue_free()
	curscene = load(scenes[goingto]).instance()
	add_child(curscene)

#This change the game border
func changeborder(newbg: int,speed: int):
	#switeches between border 1 and 2 to do the fade effect
	if (borders[0].z_index == 1):
		borders[1].frame = newbg
		anim.playback_speed = speed
		anim.play("fade1")
	elif (borders[1].z_index == 1):
		borders[0].frame = newbg
		anim.playback_speed = speed
		anim.play("fade2")

#Free border from video memory
func borderswitch(switch: bool):
	if(switch==true):
		borders[0].texture = load("res://Sprites/Border/hallborder.png")
		borders[1].texture = load("res://Sprites/Border/hallborder.png")
	else:
		borders[0].texture = null
		borders[1].texture = null
