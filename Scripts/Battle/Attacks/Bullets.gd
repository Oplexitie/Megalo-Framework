extends Node

onready var boneStabHSpr: = preload("res://Sprites/Battle/Bullets/BoneH.png")
onready var boneStabVSpr: = preload("res://Sprites/Battle/Bullets/BoneV.png")

onready var bone: = preload("res://Scenes/Battle/Attacks/Bullets/Bone/Bone.tscn")
onready var boneStab: = preload("res://Scenes/Battle/Attacks/Bullets/BoneStab/BoneStab.tscn")
onready var gasterBlaster: = preload("res://Scenes/Battle/Attacks/Bullets/GasterBlaster/GasterBlaster.tscn")
onready var platform: = preload("res://Scenes/Battle/Attacks/Bullets/Platform/Platform.tscn")

onready var playerHeart: = $"../../HeartLayer/PlayerHeart"
onready var border: = $"../../BorderLayer/Border"

onready var blackScreen: = $"../../Overlay/BlackScreen"
onready var mask: = $"../BackBufferCopy/Mask"

onready var camera: = $"../../Camera"

var placeholder_mask: = true


func toggleBlackScreen(Toggle):
	blackScreen.visible = Toggle
	if Toggle: for n in get_tree().get_nodes_in_group("Bullet"): n.queue_free()


func createBone(ZIndex, Position, Size, Direction, Speed, BulletMode: = 0.0, Angle: = 0.0, ID: = 0.0):
	var i = bone.instance()
	
	i.rect_position = Position
	i.rect_size.y = Size
	i.rect_rotation = Angle
	
	i.ID = ID
	i.bulletMode = BulletMode
	i.direction = Direction
	i.speed = Speed
	
	mask.add_child(i)
	if ZIndex == 0: i.show_behind_parent = true
	
	return i


func createBoneStab(ZIndex, Direction, Size, WaitTime, StayTime, BulletMode: = 0.0, ID: = 0.0):
	var i = boneStab.instance()
	var Warning = i.get_node("Warning")
	
	i.ID = ID
	i.bulletMode = BulletMode
	i.direction = Direction
	i.size = Size
	
	i.waitTime = WaitTime
	i.stayTime = StayTime
	
	if WaitTime > 4.0: audio.play(2, preload("res://Audio/Sounds/Warning.wav"))
	
	i.patch_margin_left = 0
	i.patch_margin_right = 0
	i.patch_margin_top = 0
	i.patch_margin_bottom = 0
	
	if Direction == 1 or Direction == 3:
		i.texture = boneStabVSpr
		i.patch_margin_top = 6
		i.patch_margin_bottom = 6
		
		i.rect_position.x = border.rect_position.x
		i.rect_size = Vector2(border.rect_size.x, Size + 8)
		
		Warning.rect_size = Vector2(border.rect_size.x - 16, Size - 3)
		
		i.idealPos.x = border.rect_position.x
		
		if Direction == 1:
			Warning.rect_position = Vector2(8, -Warning.rect_size.y - 3)
			
			i.rect_position.y = border.margin_bottom - 5
			i.idealPos.y = border.margin_bottom - 5 - Size
		if Direction == 3:
			Warning.rect_position = Vector2(8, Warning.rect_size.y + 5 + 8)
			
			i.rect_position.y = border.margin_top + 5 - i.rect_size.y
			i.idealPos.y = border.margin_top + 5 - i.rect_size.y + Size
	
	if Direction == 0 or Direction == 2:
		i.texture = boneStabHSpr
		i.patch_margin_left = 6
		i.patch_margin_right = 6
		
		i.rect_position.y = border.rect_position.y
		i.rect_size = Vector2(Size + 8, border.rect_size.y)
		
		Warning.rect_size = Vector2(Size - 3, border.rect_size.y - 16)
		
		i.idealPos.y = border.rect_position.y
		
		if Direction == 0:
			Warning.rect_position = Vector2(-Warning.rect_size.x - 3, 8)
			
			i.rect_position.x = border.margin_right - 5
			i.idealPos.x = border.margin_right - 5 - Size
		if Direction == 2:
			Warning.rect_position = Vector2(Warning.rect_size.x + 5 + 8, 8)
			
			i.rect_position.x = border.rect_position.x + 5 - i.rect_size.x
			i.idealPos.x = border.rect_position.x + 5 - i.rect_size.x + Size
	
	mask.add_child(i)
	if ZIndex == 0: i.show_behind_parent = true
	
	return i


func createGasterBlaster(ZIndex, Scale, Position, IdealPos, IdealRot, Pause, Terminal, BulletMode: = 0.0, ID: = 0.0):
	var i = gasterBlaster.instance()
	var s = i.get_node("Sprite")
	i.camera = camera
	
	i.ID = ID
	i.bulletMode = BulletMode
	
	i.position = Position
	i.ideal = IdealPos
	i.idealRot = IdealRot
	i.pause = Pause
	i.terminal = Terminal
	
	if Position == IdealPos:
		i.rotation_degrees = IdealRot
		i.position = IdealPos
	
	s.scale = Scale
	
	audio.play(5, preload("res://Audio/Sounds/Bullets/GasterBlaster.wav"), 1.2)
	
	mask.add_child(i)
	if ZIndex == 0: i.show_behind_parent = true
	
	return i


func createPlatform(ZIndex, Position, Size, Direction, Speed, BulletMode: = 0.0, Angle: = 0.0, ID: = 0.0):
	var i = platform.instance()
	
	i.rect_position = Position
	i.rect_size.x = Size
	i.rect_rotation = Angle
	
	i.ID = ID
	i.bulletMode = BulletMode
	i.direction = Direction
	i.speed = Speed
	
	mask.add_child(i)
	if ZIndex == 0: i.show_behind_parent = true
	
	return i
