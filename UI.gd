extends Node2D

var DEBUG = true
var inMenu = true
var inInstruction = false

var LIFES = 3
var FUEL = 100.0
var DISTANCE = 1000000.0

var lifesIcons = []

var nodesNotToRemove = ["Background", "Start", "CloseGame", "Instruction", "Title", "GameOver"]

var player

var timerBigAstero
var timerSmallAstero
var timerMediumAstero
var timerBonus

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if (inMenu && event is InputEventMouseButton):
	   CheckButtonsClick(event.position)
	elif Input.is_action_just_released("ui_cancel"):
		if(inMenu):
		   HandleCloseGameButton()
		elif(inInstruction):
			TurnOffInstruction()
		else:
			TurnOffGame()
			
func TurnOffInstruction():
	inInstruction = false
	RemoveNotUsedNodes()
	SetButtonsVisible(true)		
	
func RemoveNotUsedNodes():
	if(DEBUG):		
		print(print_tree_pretty())
	
	var tree = get_children()
	for node in tree:		
		var exist = false
		for item in nodesNotToRemove:			
			if(item in node.get_name()):
				exist = true
				break
			
		if(!exist):
			remove_child(node)
			node.queue_free()
				
	if(DEBUG):		
		print(print_tree_pretty())			

func TurnOffGame():
	lifesIcons.clear()
	RemoveNotUsedNodes()		
	SetButtonsVisible(true)			

func CheckButtonsClick(clickPosition):
	if(DEBUG):
		print(clickPosition)
	
	if(clickPosition.x >= 510 && clickPosition.x <= 770):
		if(clickPosition.y >= 335 && clickPosition.y <= 385):
			HandleStartButton()
		elif (clickPosition.y >= 455 && clickPosition.y <= 505):
			HandleInstructionButton()
		elif(clickPosition.y >= 575 && clickPosition.y <= 625):
			HandleCloseGameButton()
		

func HandleStartButton():
	var planet = load("planet.tscn").instance()
	planet.Init(2)
	add_child(planet)
	SetButtonsVisible(false)
	PrepareGame()
	
func HandleInstructionButton():
	var mission = load("instruction.tscn").instance()
	add_child(mission)
	SetButtonsVisible(false)
	inInstruction = true
	
func HandleCloseGameButton():
	get_tree().quit()
	
func SetButtonsVisible(value):
	if(!value):
		inMenu = false
		get_node("Title").hide()
		get_node("Start").hide()
		get_node("Instruction").hide()
		get_node("CloseGame").hide()
	else:
		inMenu = true
		get_node("Title").show()
		get_node("Start").show()
		get_node("Instruction").show()
		get_node("CloseGame").show()

	get_node("..//GameOver").hide()
		
func PrepareGame():
	for x in range(LIFES):
		var life = load("life.tscn").instance()
		life.position = Vector2(50 + x*100, 50)
		lifesIcons.append(life)
		add_child(life)
		
	var fuelBar = load("ProgressBar.tscn").instance()
	fuelBar.position = Vector2(450, 20)
	add_child(fuelBar)
		
	print(print_tree_pretty())	
		
	player = load("Player.tscn").instance()
	player.position = Vector2(90, 360)
	add_child(player)
	print(print_tree_pretty())	
	
	var score = load("ScoreLabel.tscn").instance()
	score.position = Vector2(1150, 20)
	add_child(score)	
	
	timerBigAstero = Timer.new()
	timerBigAstero.connect("timeout", self, "_on_BigAstero_timeout")
	timerBigAstero.wait_time = 5.0
	add_child(timerBigAstero)
	timerBigAstero.start()
	
	timerSmallAstero = Timer.new()
	timerSmallAstero.connect("timeout", self, "_on_SmallAstero_timeout")
	timerSmallAstero.wait_time = 2.0
	add_child(timerSmallAstero)
	timerSmallAstero.start()
	
	timerMediumAstero = Timer.new()
	timerMediumAstero.connect("timeout", self, "_on_MediumAstero_timeout")
	timerMediumAstero.wait_time = 3.5
	add_child(timerMediumAstero)
	timerMediumAstero.start()
	
	timerBonus = Timer.new()
	timerBonus.connect("timeout", self, "_on_Bonus_timeout")
	timerBonus.wait_time = 15.0
	add_child(timerBonus)
	timerBonus.start()
	
func IsPlayerMoving():
	return player.speed > 0.0 #todo zwiekszcy na jakas sensowna predkosc zeby jak jest niska to nie robilo ich caly czas
	
func _on_BigAstero_timeout():
	#todo jesli gracz stoi w miejscu to nie spawnowac
	if(IsPlayerMoving()):
		var asteroid = load("res://BigAsteroid.tscn").instance()
		add_child(asteroid)	
	
func _on_SmallAstero_timeout():
	if(IsPlayerMoving()):
		var asteroid = load("res://SmallAsteroid.tscn").instance()
		add_child(asteroid)	
	
func _on_MediumAstero_timeout():
	if(IsPlayerMoving()):
		var asteroid = load("res://MediumAsteroid.tscn").instance()
		add_child(asteroid)	

func _on_Bonus_timeout():
	if(IsPlayerMoving()):
		var bonus = load("res://Bonus.tscn").instance()
		add_child(bonus)	
		
func RemoveLife():	
	if(player.lifes > 0):
		remove_child(lifesIcons[player.lifes])
		lifesIcons[player.lifes].queue_free()
		
		var noLife = load("life.tscn").instance()
		noLife.get_node("LifeIcon").hide()
		noLife.get_node("NoLifeIcon").show()
		noLife.position = Vector2(50 + player.lifes*100, 50)
		lifesIcons[player.lifes] = noLife
		add_child(noLife)
	else:		
		GameOver()
		
func AddLife():
	if(player.lifes < 4):
		remove_child(lifesIcons[player.lifes - 1])
		lifesIcons[player.lifes - 1].queue_free()
		
		var life = load("life.tscn").instance()
		life.position = Vector2(50 + (player.lifes-1)*100, 50)
		lifesIcons[player.lifes - 1] = life
		add_child(life)
		
func GameOver():
	get_node("..//GameOver//ExplosionSound").play()	
	var leftDistance = DISTANCE - (player.distance/100.0)
	RemoveNotUsedNodes()
	lifesIcons.clear()
	var gameOverText = get_node("..//GameOver")
#	gameOverText.text = """										You Died!
#	You missed """ + String(leftDistance) + """ billions kilometers to the planet Godot
#						Game over! Press ESC to go back to menu"""
	gameOverText.bbcode_text = """[center]You Died![/center]
	[center]You missed """ + String(leftDistance) + """ billions kilometers to the planet Godot[/center]
	[center]Game over! Press ESC to go back to menu[/center]"""
	gameOverText.show()
	
func RemoveBody(body):
	remove_child(body)
	body.queue_free()