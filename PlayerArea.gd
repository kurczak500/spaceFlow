extends Area2D

func _ready():
	connect("area_entered",self,"area_entered")

func area_entered(body):
	var player = get_node("..//..//Player")
	if(player.lifes == 0):
		return
	
	if "Asteroid" in body.get_name():				
		if(!player.isShieldOn):
			player.lifes -= 1
			var root = get_node("..//..//..//Game")					
			root.RemoveLife()
			player.speed *= 0.8
		MakeExplosion(player.lifes)	
	elif("Bonus" in body.get_name()):		
		body.queue_free()
		GetBonus()
		
func GetBonus():
	var player = get_node("..//..//Player")
	randomize()
	var randomNumber = randi()%6	
	if(randomNumber == 0):
		player.fuel += 5.0
		if(player.fuel > 100.0):
			player.fuel = 100.0
	elif(randomNumber == 1):
		player.fuel -= 5.0
		if(player.fuel < 0.0):
			player.fuel = 0.0
	elif(randomNumber == 2):
		player.SlowPlayer()
	elif(randomNumber == 3):
		if(player.lifes < 3):
			player.lifes += 1
			get_node("..//..//..//Game").AddLife()
	elif(randomNumber == 4):
		player.CreateShield()
	elif(randomNumber == 5):
		player.speed = 0.0
		player.thrust = 0.0
		
func MakeExplosion(lifes):
	var explosion = load("Explosion.tscn").instance()
	if(lifes > 0):
		explosion.get_node("AnimatedExplosion").RunAnimation(0)
		get_node("..//CollisionSound").play()
	else:
		get_node("..//Spaceship").hide()
		explosion.get_node("AnimatedExplosion").RunAnimation(1)
		get_node("..//ExplosionSound").play()	
	add_child(explosion)