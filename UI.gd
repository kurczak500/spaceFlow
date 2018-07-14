extends Node2D

var DEBUG = false
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
	randomize()
	
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
	SetButtonsVisible(false)
	PrepareGame()
	
func HandleInstructionButton():
	var mission = load("Instruction.tscn").instance()
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
		var life = load("Life.tscn").instance()
		life.position = Vector2(50 + x*100, 50)
		lifesIcons.append(life)
		add_child(life)
		
	var fuelBar = load("ProgressBar.tscn").instance()
	fuelBar.position = Vector2(500, 20)
	add_child(fuelBar)
	
	if(DEBUG):	
		print(print_tree_pretty())	
		
	player = load("Player.tscn").instance()
	player.position = Vector2(90, 360)
	add_child(player)
	
	if(DEBUG):
		print(print_tree_pretty())	
	
	var score = load("ScoreLabel.tscn").instance()
	score.position = Vector2(1150, 30)
	add_child(score)
	
	var deadTimer = load("TimerLabel.tscn").instance()
	deadTimer.position = Vector2(475, 60)
	add_child(deadTimer)
	
	timerBigAstero = Timer.new()
	timerBigAstero.connect("timeout", self, "_on_BigAstero_timeout")
	timerBigAstero.wait_time = 5.3
	add_child(timerBigAstero)
	timerBigAstero.start()
	
	timerSmallAstero = Timer.new()
	timerSmallAstero.connect("timeout", self, "_on_SmallAstero_timeout")
	timerSmallAstero.wait_time = 2.0
	add_child(timerSmallAstero)
	timerSmallAstero.start()
	
	timerMediumAstero = Timer.new()
	timerMediumAstero.connect("timeout", self, "_on_MediumAstero_timeout")
	timerMediumAstero.wait_time = 3.4
	add_child(timerMediumAstero)
	timerMediumAstero.start()
	
	timerBonus = Timer.new()
	timerBonus.connect("timeout", self, "_on_Bonus_timeout")
	timerBonus.wait_time = 14.7
	add_child(timerBonus)
	timerBonus.start()
	
func Win():	
	RemoveNotUsedNodes()		
	lifesIcons.clear()
	var winningScene = load("WinningScene.tscn").instance()
	add_child(winningScene)	
	
func IsPlayerMoving():
	return (player.speed > 8000.0 || player.fuel == 0.0)
	
func _on_BigAstero_timeout():
	if(IsPlayerMoving()):
		var asteroid = load("BigAsteroid.tscn").instance()
		add_child(asteroid)	
	
func _on_SmallAstero_timeout():
	if(IsPlayerMoving()):
		var asteroid = load("SmallAsteroid.tscn").instance()
		add_child(asteroid)	
	
func _on_MediumAstero_timeout():
	if(IsPlayerMoving()):
		var asteroid = load("MediumAsteroid.tscn").instance()
		add_child(asteroid)	

func _on_Bonus_timeout():
	if(IsPlayerMoving()):
		var bonus = load("Bonus.tscn").instance()
		add_child(bonus)	
		
func RemoveLife():	
	remove_child(lifesIcons[player.lifes])
	lifesIcons[player.lifes].queue_free()
		
	var noLife = load("Life.tscn").instance()
	noLife.get_node("LifeIcon").hide()
	noLife.get_node("NoLifeIcon").show()
	noLife.position = Vector2(50 + player.lifes*100, 50)
	lifesIcons[player.lifes] = noLife
	add_child(noLife)
	
	if(player.lifes == 0):
		KillPlayer()			
		
func KillPlayer():
	player.speed = 0.0
	var deathTimer = Timer.new()
	deathTimer.connect("timeout", self, "_on_Death_timeout")
	deathTimer.wait_time = 1.5
	deathTimer.one_shot = true
	add_child(deathTimer)
	deathTimer.start()		
		
func _on_Death_timeout():
	GameOver()
		
func AddLife():
	if(player.lifes < 4):
		remove_child(lifesIcons[player.lifes - 1])
		lifesIcons[player.lifes - 1].queue_free()
		
		var life = load("Life.tscn").instance()
		life.position = Vector2(50 + (player.lifes-1)*100, 50)
		lifesIcons[player.lifes - 1] = life
		add_child(life)
		
func GameOver():
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
	
var planetsDistance = [50, 120, 200, 225, 300, 400, 500, 600, 700, 800, 990]
var currentPlanet = -1	
	
func CheckDistanceToPlanets(distanceFlown):
	if(DEBUG):
		print(distanceFlown)
	
	var iter = 0
	var canShow = false
	for item in planetsDistance:
		if(currentPlanet < iter && distanceFlown >= item*1000):
			currentPlanet = iter
			canShow = true
		iter += 1	
	
	if(canShow && currentPlanet > -1):
		var planet = load("Planet.tscn").instance()
		planet.scale = Vector2(0.5, 0.5)
		if(currentPlanet == 6):
			planet.scale = Vector2(0.8, 0.5)
			
		planet.Init(currentPlanet)
		add_child(planet)
		
		if(currentPlanet != 3):
			var planetInfo = load("InfoLabel.tscn").instance()
			planetInfo.position = Vector2(640, 690)
			planetInfo.Init(currentPlanet)
			add_child(planetInfo)	
			
func TimeEnd():
	var explosion = load("Explosion.tscn").instance()
	get_node("Player//Spaceship").hide()
	explosion.get_node("AnimatedExplosion").RunAnimation(2)
	add_child(explosion)
	get_node("Player//ExplosionSound").play()
	KillPlayer()