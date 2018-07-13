extends Node

var counter = 0
onready var missionText = get_node("Mission")
var currentSign = 0
var SHOW = 20 #when show sign

var text = """You just kidnapped new prototype spaceship near Sun.
Bad news is that you lost automatic pilot and you must controll spaceship by yourself.
This spaceship give you opportunity to leave solar system and reach new colony on Godot planet.
This is your only chance to escape Earth. You have limited fuel so you must manage it properly. 
Spaceship isn't prepared for long travel. There is very little water and food.
Because of that you have limited time to reach your target.
Watch out for asteroids! Good Luck! You will need it :)

Press ESC to go back to menu
"""

func _process(delta):
	if(currentSign == text.length()):
		return
	
	counter += 1
	if(counter == SHOW):
		missionText.text += text[currentSign].to_upper()
		currentSign += 1
		counter = 0
	