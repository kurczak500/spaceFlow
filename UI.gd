extends Node2D

var DEBUG = true
var inMenu = true

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if event is InputEventMouseButton:
	   CheckButtonsClick(event.position)
	elif Input.is_action_pressed("ui_cancel"):
		if(inMenu):
		   HandleCloseGameButton()
		else:
		   #add close game
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
	