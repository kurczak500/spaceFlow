extends Node

var counter = 0
onready var missionText = get_node("Mission")
var currentSign = 0
var SHOW = 10 #when show sign

var text = """You just kidnapped new prototype spaceship near Sun.
Bad news is that you lost automatic pilot and you must control spaceship by yourself.
Spaceship give you opportunity to leave solar system and reach colony on Godot planet.
This is your only chance to escape Earth. 
You have limited fuel so you must manage it properly. 
Spaceship isn't prepared for long travel. There is very little water and food.
Because of that you have limited time to reach your target.
Watch out for bonuses! It could not be bonus. Good Luck! You will need it :)

Controls:
Up/Down - move Up/Down - not using fuel
Left - backward thrust
Right - forward thrust

HUD:
Progress bar - remaining fuel
Right corner number - distance to Godot planet
Timer - left time to reach Godot planet

Press ESC to go back to menu"""

func _ready():
	get_node("ComputerSound").play()

func _process(delta):
	if(currentSign == text.length()):
		return
	
	counter += 1
	if(counter == SHOW):
		missionText.text += text[currentSign].to_upper()
		currentSign += 1
		counter = 0
	