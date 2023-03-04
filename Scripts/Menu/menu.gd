extends Node2D

onready var gameviewport = 	$"../../Viewport"
onready var areacontrol = 	$"../../../../Control"
onready var viewconta = 	$"../../../ViewportContainer"

#[0] is for resolution, #[1] is for FPS
var opt_config = [0,1,40]		#left and right options
var opt_select = 0		#up and down options

onready var text_obj = [$CanvasLayer/ScreenSelect,$CanvasLayer/FPSSelect,$CanvasLayer/AudioSelect]

var text_resol = ["","",""]
var text_color = ["","",""]

var left_held = false
var right_held = false
var up_held = false
var down_held = false

var hasborder = false
var loadingdone = false

var aftertext = "%      >"
var cooldown = 0

func _input(event):
	if event.is_action_pressed("ui_left"):
		if not left_held:
			opt_config[opt_select] -= 1
			loadingdone = false
		left_held = true
	elif event.is_action_released("ui_left"):
		left_held = false
		
	if event.is_action_pressed("ui_right"):
		if not right_held:
			opt_config[opt_select] += 1
			loadingdone = false
		right_held = true
	elif event.is_action_released("ui_right"):
		right_held = false
			
	if event.is_action_pressed("ui_up"):
		if not up_held:
			opt_select -= 1
			loadingdone = false
		up_held = true
	elif event.is_action_released("ui_up"):
		up_held = false
		
	if event.is_action_pressed("ui_down"):
		if not down_held:
			opt_select += 1
			loadingdone = false
		down_held = true
	elif event.is_action_released("ui_down"):
		down_held = false
		
	if event.is_action_pressed("ui_accept"):
		gameviewport.loadScene(0)

func _ready():
	resolution_change(Vector2(640,480),false,false)
	text_resol[0] = "<      Windowed       >"
	text_resol[1] = "<       60FPS         >"
	text_resol[2] = "<      Audio 40%      >"
	text_color[0] = "[color=#ffffff]"
	text_color[1] = "[color=#646464]"
	text_color[2] = "[color=#646464]"
	update_text()
	audio.volumeDB = (opt_config[2] - 80) /2

func _physics_process(delta):
	#loading done checks if action is completed, if it is, it won't do the same thing over and over
	if loadingdone == false:
		#opt_select selects the option (up/down), while opt_config[] modifies the options (left/right)
		match opt_select:
			-1: opt_select = 2
			0:
				match opt_config[0]:
					-1: opt_config[0] = 3
					0: 
						resolution_change(Vector2(640,480),false,false)
						text_resol[0] = "<      Windowed       >"
					1: 
						resolution_change(Vector2(1280,960),false,false)
						text_resol[0] = "<     Windowed x2     >"
					2: 
						resolution_change(Vector2(640,480),true,false)
						text_resol[0] = "<     Fullscreen      >"
					3: 
						resolution_change(Vector2(1920,1080),true,true)
						text_resol[0] = "< Fullscreen + Border >"
					4: opt_config[0] = 0
					_: opt_config[0] = 0
				text_color[0] = "[color=#ffffff]"
				text_color[1] = "[color=#646464]"
				text_color[2] = "[color=#646464]"
				update_text()
			1: 
				match opt_config[1]:
					-1: opt_config[1] = 4
					0: 
						text_resol[1] = "<       30FPS         >"
						Engine.target_fps = 30
						loadingdone = true
					1: 
						text_resol[1] = "<       60FPS         >"
						Engine.target_fps = 60
						loadingdone = true
					2: 
						text_resol[1] = "<       75FPS         >"
						Engine.target_fps = 75
						loadingdone = true
					3: 
						text_resol[1] = "<       120FPS        >"
						Engine.target_fps = 120
						loadingdone = true
					4: 
						text_resol[1] = "<       144FPS        >"
						Engine.target_fps = 144
						loadingdone = true
					5: opt_config[1] = 0
					_: opt_config[1] = 0
				text_color[0] = "[color=#646464]"
				text_color[1] = "[color=#ffffff]"
				text_color[2] = "[color=#646464]"
				update_text()
			2:
				if (cooldown==0):
					if(left_held==true or right_held==true):
						if(opt_config[opt_select]>0 and opt_config[opt_select]<100):
							opt_config[2] += int(right_held) - int(left_held)
							audio.volumeDB = (opt_config[2] - 80) /2
							cooldown = 7
							
						if(opt_config[2]>=100):
							aftertext="%     >"
							opt_config[2]=100
						elif(opt_config[2]<=0):
							opt_config[2]=0
							audio.volumeDB = -80
						elif(opt_config[2]<10):
							aftertext="%       >"
						else:
							aftertext="%      >"
				
				if(cooldown>0):
					cooldown-=1
				else:
					loadingdone = true
				
				text_resol[2] = "<      Audio "+str(opt_config[2])+aftertext
				text_color[0] = "[color=#646464]"
				text_color[1] = "[color=#646464]"
				text_color[2] = "[color=#ffffff]"
				update_text()
			3: opt_select = 0
			_: opt_select = 0


func resolution_change(resolution, isfull, hasborder):
	#switches to stretch for a bit so it can include the fullscreen border
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_EXPAND,Vector2(resolution[0],resolution[1]),1)
	viewconta.rect_scale = Vector2(1 + int(hasborder), 1 + int(hasborder))
	viewconta.anchor_left = 0 + float(hasborder)/2
	viewconta.anchor_top = 0 + float(hasborder)/2
	viewconta.anchor_right = 0 + float(hasborder)/2
	viewconta.anchor_bottom = 0 + float(hasborder)/2
	areacontrol.margin_right = resolution[0]
	areacontrol.margin_bottom = resolution[1]
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP,Vector2(640 + 640 * (int(hasborder)*2),480 + 480 * (int(hasborder)*1.25)),1)
	OS.window_fullscreen = isfull
	OS.set_window_size(Vector2(resolution[0], resolution[1]))
	loadingdone = true
	
func update_text():
	text_obj[0].bbcode_text= text_color[0] + text_resol[0]
	text_obj[1].bbcode_text= text_color[1] + text_resol[1]
	text_obj[2].bbcode_text= text_color[2] + text_resol[2]
