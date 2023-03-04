extends Position2D

var ID: = 0
var action: = ""
var backAction: = ""


func _process(_delta: float) -> void: if has_node("Text") and action == "": $Text.modulate = Color(0.5, 0.5, 0.5)
