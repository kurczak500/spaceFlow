extends Node2D

#consts
var ZERO = 0.0;
var VERTICALLY_SPEED = 0.1
var DRAG = 0.98 #nie istnieje w kosmosie, ale to nie symulacja :D
var SPRITE_SIZE_Y = 146
var Y_SIZE = 720
var DEBUG = false

#vars
var velocity = Vector2(ZERO, 0.0)
var lifes = 0
var thrust = 0
var fuel = 0
var distance = 0
var speed = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	lifes = get_parent().LIFES #get lifes from root
	fuel = get_parent().FUEL #get fuel from root
	
func _physics_process(delta):
	velocity *= DRAG
	position += velocity
	AcceptPosition()
		
	#speed += thrust
	distance += speed
	
	if(DEBUG):
		print("position " + String(position))
		print("velocity " + String(velocity))
		print("thrust " + String(thrust))
		print("distance " + String(distance))
		print("speed " + String(speed))

func _process(delta):
	if Input.is_action_pressed("ui_right"): #prawo - zwiekszamy thrust
		if(thrust < 100):
			thrust += 1			
		
	if Input.is_action_pressed("ui_left"): #lewo - zmniejszamy thrust
		speed += 1
		if(thrust > 0):
			thrust -= 1
	if Input.is_action_pressed("ui_up"): #gora - przesuwamy w gore
		velocity -= Vector2(ZERO, VERTICALLY_SPEED)
	if Input.is_action_pressed("ui_down"): #dol - przesuwamy w dol
		velocity += Vector2(ZERO, VERTICALLY_SPEED)
	
func AcceptPosition():
	if(position.y < 0 + SPRITE_SIZE_Y/2 || position.y > Y_SIZE - SPRITE_SIZE_Y/2):
		position -= velocity
		velocity = Vector2(ZERO, ZERO)
		
var planetsDistance = [100, 200, 300, 325, 500, 700, 900, 1300, 1600, 1800, 2200]
