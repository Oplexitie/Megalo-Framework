extends NinePatchRect

var ideal: Array = [32, 250, 607, 390]
var speed: = 480
var isinstant = false

var resizeDone: = false
onready var collisions = [$Collisions/Left, $Collisions/Top, $Collisions/Right, $Collisions/Bottom]
var margins = [margin_left, margin_top, margin_right, margin_bottom]
signal resizeFinished

onready var backbuff = [$"../../Attacks/BackBufferCopy/Mask/Top", $"../../Attacks/BackBufferCopy/Mask/Bottom"]
onready var corners = [$CornerTop, $CornerBottom]
onready var camera = $"../../Camera"

func _physics_process(delta: float) -> void:
	var xers: Array = [0, 0, 0, 0]
	
	if (!isinstant):
		for r in 4:
			# Border speed setter.
			xers[r] = min(speed * delta, abs(margins[r] - ideal[r]))
			# Border resizing
			if margins[r] > ideal[r]: margins[r] -= xers[r]
			elif margins[r] < ideal[r]: margins[r] += xers[r]
			
			#Applies the changes to the border sides
			margin_left = margins[0]
			margin_top = margins[1]
			margin_right = margins[2]
			margin_bottom = margins[3]
			
		if !resizeDone:
		# Emit signal once all = ideal
			if (margins == ideal):
				resizeDone = true
				#print("Border resize complete")
				emit_signal("resizeFinished")
	else:
		for c in 4:
			margins[c] = ideal[c]
		margin_left = margins[0]
		margin_top = margins[1]
		margin_right = margins[2]
		margin_bottom = margins[3]
		resizeDone = true
		emit_signal("resizeFinished")
	
	
	rect_pivot_offset = rect_size / 2.0 # Center the pivot for rotation
	
	collisions[0].shape.extents = Vector2(480, 640)
	collisions[1].shape.extents = Vector2(640, 480)
	collisions[2].shape.extents = collisions[0].shape.extents
	collisions[3].shape.extents = collisions[1].shape.extents
	
	collisions[0].position = Vector2(-collisions[0].shape.extents.x + 5, collisions[0].shape.extents.y - 480)
	collisions[1].position = Vector2(rect_size.x / 2.0, -collisions[1].shape.extents.y + 5)
	collisions[2].position = Vector2(rect_size.x + collisions[2].shape.extents.x - 5, collisions[2].shape.extents.y - 480)
	collisions[3].position = Vector2(rect_size.x / 2.0, rect_size.y + collisions[1].shape.extents.y - 5)
	
	# Places the CornerBottom node to the bottom corner of the Border
	# CornerTop sticks to the top corner always, so that's why I didn't write code for it
	corners[1].position = rect_size - Vector2(5, 5)


func _process(delta):
	# Places the Backbuffers in the right position according to where the border is
	backbuff[0].position = corners[0].global_position
	backbuff[0].rotation = corners[0].global_rotation
	backbuff[1].position = corners[1].global_position
	backbuff[1].rotation = corners[1].global_rotation
	
	# Adjusts the Backbuffer sizes depending on camera zoom
	backbuff[0].scale = camera.zoom * 200.0
	backbuff[1].scale = camera.zoom * 200.0

func changeSize(Left: = margin_left, Right: = margin_right, Top: = margin_top, Bottom: = margin_bottom, newSpeed: = speed, isitinstant = false):
	isinstant = isitinstant
	resizeDone = false
	ideal = [Left, Top, Right, Bottom]
	speed = newSpeed
