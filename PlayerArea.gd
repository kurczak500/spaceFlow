extends Area2D

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	connect("area_entered",self,"area_entered")

func area_entered(body):
	print(body.get_name())
	if "Asteroid" in body.get_name():		
		var player = get_node("..//..//Player")
		player.lifes -= 1
		var root = get_node("..//..//..//Game")					
		root.RemoveLife()
		MakeExplosion(player.lifes)	
	elif("Bonus" in body.get_name()):		
		body.queue_free()
		GetBonus()
		
func GetBonus():
	var player = get_node("..//..//Player")
	var randomNumber = randi()%5	
	if(randomNumber == 0):
		pass
	elif(randomNumber == 1):
		pass
	elif(randomNumber == 2):
		pass
	elif(randomNumber == 3):
		pass
	elif(randomNumber == 4):
		pass
	elif(randomNumber == 5): #todo nwm czy bedzie czy wywalic
		pass
		
func MakeExplosion(lifes):
	var explosion = load("res://Explosion.tscn").instance()
	if(lifes > 0):
		explosion.get_node("AnimatedExplosion").RunAnimation(true)
	else:
		explosion.get_node("AnimatedExplosion").RunAnimation(false)
	add_child(explosion)