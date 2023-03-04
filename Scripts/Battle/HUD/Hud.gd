extends CanvasLayer

var menuCoord: = [0, 0]
var menuNo: = -1

var menuSize: = 1
var inputLimit: = Vector2(0, 0)

var actSelection: = 0

var InfoText: Array = ["* You feel extremely unstable...", 1.0, {}, {}]
var preTextEffects: Array = [true, "[tremble freq=1 chance=1]", "[/tremble]"]

var spareOptions = [["Spare", "menuSpare"]]

onready var defaultFontSettings: = {
	"Font" : preload("res://Fonts/Determination Mono (Menu).tres"),
	"Color" : Color(1, 1, 1),
	"Sound" : "Sounds/Voice/Typer",
}
onready var richTextEffects: Array = [
	preload("res://Scripts/RPGText/RichTextEffects/Tremble/Tremble.tres"),
]

onready var menuOptionScr: = preload("res://Scripts/Battle/HUD/MenuOption.gd")
onready var rpgTextScr: = preload("res://Scripts/RPGText/RPGText.gd")

onready var playerHeart: = $"../HeartLayer/PlayerHeart"
onready var enemy: = $"../Enemy"
onready var target: = preload("res://Scenes/Battle/HUD/Target/Target.tscn")

onready var buttons = $Buttons
onready var itembutt = $Buttons/Item
onready var healthbar = $HealthBar

signal runAttack # Connected from Battle.gd


func _input(event: InputEvent) -> void:
	for n in get_tree().get_nodes_in_group("MenuOption"):
		if n.ID == menuCoord[menuNo] and menuNo >= 0:
			if n.action != "" and event.is_action_pressed("ui_accept"):
				if menuNo == 0: menuNo = 1
				call(n.action)
				audio.play("Sounds/MenuConfirm")
			
			elif n.backAction != "" and event.is_action_pressed("ui_cancel"):
				menuCoord[1] = 0
				call(n.backAction)
	
	var menuInput: = Vector2(
		int(event.is_action_pressed("ui_right")) - int(event.is_action_pressed("ui_left")),
		int(event.is_action_pressed("ui_down")) - int(event.is_action_pressed("ui_up"))
		)
	
	if menuNo >= 0:
		menuCoord[menuNo] = posmod(menuCoord[menuNo] + menuInput.x * inputLimit.x, menuSize)
		menuCoord[menuNo] = posmod(menuCoord[menuNo] + menuInput.y * inputLimit.y, menuSize)
		if menuNo == 0 and menuInput.x: audio.play("Sounds/MenuMove")


func _process(_delta: float) -> void:
	if menuNo == 1 and menuCoord[0] == itembutt.id:
		for n in get_tree().get_nodes_in_group("MenuOption"):
			if n.ID == menuCoord[menuNo] and menuNo != 0:
				if n.position.x > 640: for t in get_tree().get_nodes_in_group("MenuOption"): t.position.x -= 640
				if n.position.x < 0: for t in get_tree().get_nodes_in_group("MenuOption"): t.position.x += 640
		
		for n in get_tree().get_nodes_in_group("RPGText"):
			if n.textName == "ItemPageText":
				var pageString: = "PAGE " + str(floor(menuCoord[1] / 4.0) + 1)
				n.bbcode_text = preTextEffects[1] + pageString + preTextEffects[2] if preTextEffects[0] else pageString
				pass
	
	for n in get_tree().get_nodes_in_group("MenuOption"):
		if n.ID == menuCoord[menuNo] and menuNo >= 0: playerHeart.position = Vector2(n.position.x + 8, n.position.y + 12)
	
	for n in buttons.get_children():
		if menuNo == 0:
			n.frame = 0
			if n.id == menuCoord[menuNo]: n.frame = 1
		elif menuNo < 0: n.frame = 0
	
	healthbar.position.x = 240 if global.kr <= -1 else 220


func createMenuOption(Position, ID, Text, Action, BackAction):
	var i: = Position2D.new()
	i.set_script(menuOptionScr)
	
	i.position = Position
	i.ID = ID
	i.action = Action
	i.backAction = BackAction
	
	add_child(i)
	i.add_to_group("MenuOption")
	
	if Text != "":
		var t: = RichTextLabel.new()
		t.name = "Text"
		
		t.rect_position = Vector2(32, 0)
		t.rect_size = Vector2(512, 96)
		
		t.scroll_active = false
		t.rect_clip_content = false
		t.bbcode_enabled = true
		
		t.custom_effects = richTextEffects
		
		t.set("custom_fonts/normal_font", defaultFontSettings["Font"])
		t.set("theme_override_colors/default_color", defaultFontSettings["Color"])
		
		var effectText: String = preTextEffects[1] + Text + preTextEffects[2]
		t.bbcode_text = effectText if preTextEffects[0] else Text
		
		i.add_child(t)
	
	return i


func createRPGText(Name, Position, Size, Text, TextSpeed, SetSpeed, SetPause, Interactable: = true, DestroyTime = INF, Skip: = false, ID: = 0):
	var i: = RichTextLabel.new()
	i.rect_position = Position
	i.rect_size = Size
	
	i.scroll_active = false
	i.rect_clip_content = false
	i.bbcode_enabled = true
	
	i.custom_effects = richTextEffects
	
	i.set("custom_fonts/normal_font", defaultFontSettings["Font"])
	i.set("theme_override_colors/default_color", defaultFontSettings["Color"])
	
	var effectText: String = preTextEffects[1] + Text + preTextEffects[2]
	i.bbcode_text = effectText if preTextEffects[0] else Text
	
	i.set_script(rpgTextScr)
	
	if Skip: i.charCount = len(Text)
	
	i.ID = ID
	i.textName = Name
	
	i.textSound = defaultFontSettings["Sound"]
	i.speed = TextSpeed
	i.setSpeed = SetSpeed
	i.setPause = SetPause
	
	i.interactable = Interactable
	i.destroyTime = DestroyTime
	
	add_child(i)
	i.add_to_group("RPGText")
	
	return i


func menuClear(Reset = false):
	if Reset:
		inputLimit = Vector2(0, 0)
		menuNo = -1
		playerHeart.position = Vector2(640, 480) * -2
	
	for n in get_tree().get_nodes_in_group("RPGText"): n.queue_free()
	for n in get_tree().get_nodes_in_group("MenuOption"): n.queue_free()


func menuBattle():
	menuNo = 0
	menuCoord[1] = 0
	
	menuClear()
	for n in buttons.get_children(): createMenuOption(Vector2(n.global_position.x + 8, n.global_position.y + 10), n.id, "", n.function, "")
	
	menuSize = len(buttons.get_children())
	inputLimit = Vector2(1, 0)
	
	createRPGText("InfoText", Vector2(48, 272), Vector2(544, 196), InfoText[0], InfoText[1], InfoText[2], InfoText[3])


func menuEnemyList(Action):
	inputLimit = Vector2(0, 1)
	
	menuSize = len(enemy.Name)
	for n in menuSize: createMenuOption(Vector2(64, 272 + n * 32), n, "* " + enemy.Name[n], Action, "menuBattle")


func menuFight():
	menuClear(); menuEnemyList("menuFightEnemy")
func menuAct():
	menuClear(); menuEnemyList("menuActEnemy")


func menuFightEnemy():
	menuClear(true)
	
	var t = target.instance()
	t.position = Vector2(320, 320)
	t.currEnemy = menuCoord[1]
	t.enemyStrikePos = enemy.enemyStrikePos[menuCoord[1]]
	t.connect("playerAttack", enemy, "playerAttack")
	t.connect("playerMiss", enemy, "createDamageWriter", [Vector2(270, 75), 114, 0, 30])
	t.connect("playerMiss", self, "skipAttack")
	
	add_child(t)


func menuActEnemy():
	inputLimit = Vector2(1, 2)
	
	menuSize = len(enemy.actOptions)
	
	menuClear()
	
	for n in menuSize: createMenuOption(Vector2(64 + (n % 2) * 256, 272 + floor(n / 2) * 32), n, "* " + enemy.actOptions[n][0], "menuActText", "menuAct")	
	menuCoord[1] = 0



func menuActText():
	menuClear(true)
	
	var actText: Array = enemy.actChoiceText[0][menuCoord[1]]
	
	for n in len(actText):
		if len(actText) == 1:
			enemy.actChoiceText[0][0].append(["* Can't keep dodging forever.\n  Keep attacking.", 1.0, {}, {}])
		
		var text = createRPGText("ActText", Vector2(48, 272), Vector2(544, 196), actText[n][0], actText[n][1], actText[n][2], actText[n][3])
		yield(text, "con")
	
	emit_signal("runAttack")


func menuItem():
	if len(global.item) > 0:
		inputLimit = Vector2(1, 2)
		menuSize = len(global.item)
		
		menuClear()
		
		if menuSize > 0:
			for n in min(4, len(global.item)):
				createMenuOption(Vector2(64 + (n % 2) * 256, 272 + floor(n / 2) * 32), n, "* " + global.item[n][0], "menuUseItem", "menuBattle")
		
		if menuSize > 4:
			for n in min(4, len(global.item) - 4):
				createMenuOption(Vector2(640 + 64 + (n % 2) * 256, 272 + floor(n / 2) * 32), n + 4, "* " + global.item[n + 4][0], "menuUseItem", "menuBattle")
		
		if menuSize > 8:
			for n in min(4, len(global.item) - 8):
				createMenuOption(Vector2(1280 + 64 + (n % 2) * 256, 272 + floor(n / 2) * 32), n + 8, "* " + global.item[n + 8][0], "menuUseItem", "menuBattle")
		
		createRPGText("ItemPageText", Vector2(384, 336), Vector2(256, 32), "PAGE 1", 0, {}, {}, false, INF, true)
	else:
		for n in get_tree().get_nodes_in_group("RPGText"): if n.textName == "InfoText": n.queue_free()
		menuNo = 0
		createRPGText("InfoText", Vector2(48, 272), Vector2(544, 196), InfoText[0], InfoText[1], InfoText[2], InfoText[3], false, INF, true)


func menuUseItem():
	audio.play("Sounds/Player/Heal")
	menuClear(true)
	
	var HealText: = ""
	var ExtraText: = ""
	
	if global.item[menuCoord[1]][2] != "": ExtraText = "* " + global.item[menuCoord[1]][2] + "\n"
	
	if global.hp + global.item[menuCoord[1]][3] <= global.maxHP:
		global.hp += int(global.item[menuCoord[1]][3])
		HealText = "* You recovered " + str(global.item[menuCoord[1]][3]) + " HP!"
	else:
		global.hp = global.maxHP
		HealText = "* Your HP has been maxed out."
	
	var text = createRPGText("ItemUseText", Vector2(48, 272), Vector2(544, 196), "* You ate the " + global.item[menuCoord[1]][1] + ".\n" + ExtraText + HealText, 1.0, {}, {})
	global.item.remove(menuCoord[1])
	
# warning-ignore:redundant_await
	yield(text, "con")
	emit_signal("runAttack")


func menuMercy():
	inputLimit = Vector2(0, 1)
	menuClear()
	menuSize = len(spareOptions)
	
	for n in menuSize: createMenuOption(Vector2(64, 272 + n * 32), n, "* " + spareOptions[n][0], spareOptions[n][1], "menuBattle")


func menuSpare():
	menuClear(true)
	emit_signal("runAttack")


func skipAttack(): emit_signal("runAttack")
