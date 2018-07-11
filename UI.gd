extends Node2D

var DEBUG = true
var inMenu = true

var LIFES = 3
var FUEL = 100

var lifesIcons = []

var nodesNotToRemove = ["Background", "Start", "CloseGame", "HighScores", "Title"]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if (inMenu && event is InputEventMouseButton):
	   CheckButtonsClick(event.position)
	elif Input.is_action_pressed("ui_cancel"):
		if(inMenu):
		   HandleCloseGameButton()
		else:
			TurnOffGame()
			
func TurnOffGame():
	lifesIcons.clear()
	
	if(DEBUG):		
		print(print_tree_pretty ())
	
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
		print(print_tree_pretty ())
		
	SetButtonsVisible(true)			

func CheckButtonsClick(clickPosition):
	if(DEBUG):
		print(clickPosition)
	
	if(clickPosition.x >= 510 && clickPosition.x <= 770):
		if(clickPosition.y >= 335 && clickPosition.y <= 385):
			HandleStartButton()
		elif (clickPosition.y >= 455 && clickPosition.y <= 505):
			HandleHighScoreButton()
		elif(clickPosition.y >= 575 && clickPosition.y <= 625):
			HandleCloseGameButton()
		

func HandleStartButton():
	var planet = load("planet.tscn").instance()
	planet.Init(2)
	add_child(planet)
	SetButtonsVisible(false)
	PrepareGame()
	
func HandleHighScoreButton():
	pass
	
func HandleCloseGameButton():
	get_tree().quit()
	
func SetButtonsVisible(value):
	if(!value):
		inMenu = false
		get_node("Title").hide()
		get_node("Start").hide()
		get_node("HighScores").hide()
		get_node("CloseGame").hide()
	else:
		inMenu = true
		get_node("Title").show()
		get_node("Start").show()
		get_node("HighScores").show()
		get_node("CloseGame").show()
		
func PrepareGame():
	for x in range(LIFES):
		var life = load("life.tscn").instance()
		life.position = Vector2(50 + x*100, 50)
		lifesIcons.append(life)
		add_child(life)
		
	var player = load("Player.tscn").instance()
	player.position = Vector2(120, 360)
	add_child(player)
	
	var score = load("res://resources/ScoreLabel.tscn").instance()
	score.position = Vector2(1200, 20)
	add_child(score)
	
	var fuelBar = load("res://resources/ProgressBar.tscn").instance()
	fuelBar.position = Vector2(450, 20)
	add_child(fuelBar)
	