extends Node2D

# Player stuff
var playerName: = "Scarm"
var lv: = 19
var maxHP: = 16 + (lv * 4)
var hp: = maxHP
var at: = 8 + (lv * 2)
var df: = 9 + ceil(lv / 4)
var kr: = 0
var inv: = 45 # Invulnerability/Invincibility
var wepStrength: = 20
var item: Array = []

# Game Over stuff
var deathHeartPos = Vector2(320,240)
var deathHeratCol = Color(255,0,0)
