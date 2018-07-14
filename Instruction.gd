extends Node

var counter = 0
onready var missionText = get_node("Mission")
var currentSign = 0
var SHOW = 10 #when show sign

onready var soundNode = get_node("ComputerSound")

var text = """You just kidnapped new prototype spaceship near Sun. 
Bad news is that you lost automatic pilot and you must control spaceship by yourself.
Spaceship give you opportunity to leave solar system and reach colony on Godot planet.
This is your only chance to escape Earth. You have limited fuel so you must manage it properly. 
You have limited time to reach your target, because there are missles chasing you.
Watch out for bonuses! It could not be bonus. Good Luck! You will need it :)

Controls:
Up/Down - move Up/Down - not using fuel
Left/Right arrow - backward/forward thrust
Space - set thrust to zero

HUD:
Progress bar - remaining fuel
Right corner number - distance to Godot planet
Timer - time left to reach Godot planet

Press ESC to go back to menu"""

func _ready():
	soundNode.play()

func _process(delta):
	if(currentSign == text.length()):
		if(soundNode.is_playing()):
			soundNode.stop()
		return
	
	counter += 1
	if(counter == SHOW):
		missionText.text += text[currentSign].to_upper()
		currentSign += 1
		counter = 0
		if(!soundNode.is_playing()):
			soundNode.play()
	