extends Node2D

#consts
var ZERO = 0.0;
var VERTICALLY_SPEED = 0.1
var DRAG = 0.98 #nie istnieje w kosmosie, ale to nie 100% symulacja :D
var SPRITE_SIZE_Y = 146/2
var Y_SIZE = 720

#vars
var velocity = Vector2(ZERO, 0.0)
var lifes = 0
var thrust = 0.0
var fuel = 0.0
var distance = 0.0
var speed = 0.0

onready var progressBar = get_node("..//ProgressBarNode//ProgressBar")

func _ready():
	lifes = get_parent().LIFES #get lifes from root
	fuel = get_parent().FUEL #get fuel from root
	
func _physics_process(delta):
	if(fuel <= 0.0):
		fuel = 0.0
		thrust = 0.0
		
	progressBar.value = fuel
	speed += thrust
	if(speed < 0.0):
		speed = 0.0
		thrust = 0.0
		
	distance += speed
	
	if(thrust != 0.0):
		fuel -= (abs(thrust)/1000.0)
		
	velocity *= DRAG
	position += velocity
	AcceptPosition()
		
	var properDistance = get_parent().DISTANCE - (distance/100.0)	
	get_node("..//Score//ScoreLabel").text = String(int(properDistance))
	
	if(properDistance <= 0.0):
		get_parent().Win()
		return
	
	get_parent().CheckDistanceToPlanets(distance/100.0)
	ThrustControl()

func _process(delta):
	if(lifes == 0):
		return
		
	if Input.is_action_pressed("ui_right"): #prawo - zwiekszamy thrust
		if(thrust < 100):
			thrust += 0.5					
	if Input.is_action_pressed("ui_left"): #lewo - zmniejszamy thrust
		if(thrust > -100):
			thrust -= 0.5
	if Input.is_action_pressed("ui_up"): #gora - przesuwamy w gore
		velocity -= Vector2(ZERO, VERTICALLY_SPEED)
	if Input.is_action_pressed("ui_down"): #dol - przesuwamy w dol
		velocity += Vector2(ZERO, VERTICALLY_SPEED)
	if Input.is_action_just_released("ui_select"): #spacja - thrust na 0
		thrust = 0.0
	
func AcceptPosition():
	if(position.y < 0 + SPRITE_SIZE_Y/2 || position.y > Y_SIZE - SPRITE_SIZE_Y/2):
		position -= velocity
		velocity = Vector2(ZERO, ZERO)
		

var slowerTimer
var shieldTimer
var isShieldOn = false

func SlowPlayer():
	slowerTimer = Timer.new()
	slowerTimer.connect("timeout", self, "_on_slower_timeout")
	slowerTimer.wait_time = 5.0
	slowerTimer.one_shot = true
	add_child(slowerTimer)
	slowerTimer.start()
	VERTICALLY_SPEED = 0.008
	
func _on_slower_timeout():
	slowerTimer.queue_free()
	VERTICALLY_SPEED = 0.1
	
func CreateShield():
	shieldTimer = Timer.new()
	shieldTimer.connect("timeout", self, "_on_shield_timeout")
	shieldTimer.wait_time = 5.0
	shieldTimer.one_shot = true
	add_child(shieldTimer)
	shieldTimer.start()
	get_node("Shield").show()
	isShieldOn = true

func _on_shield_timeout():
	shieldTimer.queue_free()
	get_node("Shield").hide()
	isShieldOn = false
	
func ThrustControl():
	var positiveThrust = get_node("PositiveThrust")
	var negativeThrust = get_node("NegativeThrust")
	if(thrust == 0.0 || lifes == 0):
		positiveThrust.hide()
		negativeThrust.hide()
		return
		
	if(thrust > 0.0):
		negativeThrust.hide()
		if(thrust <= 10.0):
			positiveThrust.scale = Vector2(1.0, 0.3)
		elif(thrust <= 20.0):
			positiveThrust.scale = Vector2(1.0, 0.4)
		elif(thrust <= 30.0):
			positiveThrust.scale = Vector2(1.0, 0.5)
		elif(thrust <= 40.0):
			positiveThrust.scale = Vector2(1.0, 0.6)
		elif(thrust <= 50.0):
			positiveThrust.scale = Vector2(1.0, 0.7)
		elif(thrust <= 60.0):
			positiveThrust.scale = Vector2(1.0, 0.8)
		elif(thrust <= 70.0):
			positiveThrust.scale = Vector2(1.0, 0.9)
		elif(thrust <= 80.0):
			positiveThrust.scale = Vector2(1.0, 1.0)
		elif(thrust <= 90.0):
			positiveThrust.scale = Vector2(1.0, 1.05)
		elif(thrust <= 100.0):
			positiveThrust.scale = Vector2(1.0, 1.117773)
			
		positiveThrust.show()
	elif(thrust < 0.0):
		positiveThrust.hide()
		if(thrust >= -10.0):
			negativeThrust.scale = Vector2(1.0, 0.5)
		elif(thrust >= -20.0):
			negativeThrust.scale = Vector2(1.0, 0.6)
		elif(thrust >= -30.0):
			negativeThrust.scale = Vector2(1.0, 0.7)
		elif(thrust >= -40.0):
			negativeThrust.scale = Vector2(1.0, 0.8)
		elif(thrust >= -50.0):
			negativeThrust.scale = Vector2(1.0, 0.9)
		elif(thrust >= -60.0):
			negativeThrust.scale = Vector2(1.0, 1.0)
		elif(thrust >= -70.0):
			negativeThrust.scale = Vector2(1.0, 1.1)
		elif(thrust >= -80.0):
			negativeThrust.scale = Vector2(1.0, 1.2)
		elif(thrust >= -90.0):
			negativeThrust.scale = Vector2(1.0, 1.3)
		elif(thrust >= -100.0):
			negativeThrust.scale = Vector2(1.0, 1.467873)
			
		negativeThrust.show()