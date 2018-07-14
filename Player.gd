extends Node2D

#consts
var ZERO = 0.0;
var VERTICALLY_SPEED = 0.1
var DRAG = 0.98 #nie istnieje w kosmosie, ale to nie 100% symulacja :D
var SPRITE_SIZE_Y = 146/2
var Y_SIZE = 720
var DEBUG = false

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
	
	if(DEBUG):
		print("position " + String(position))
		print("velocity " + String(velocity))
		print("thrust " + String(thrust))
		print("distance " + String(distance))
		print("speed " + String(speed))

func _process(delta):
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
	add_child(slowerTimer)
	slowerTimer.start()
	VERTICALLY_SPEED = 0.008
	
func _on_slower_timeout():
	slowerTimer.stop()
	slowerTimer.queue_free()
	VERTICALLY_SPEED = 0.1
	
func CreateShield():
	shieldTimer = Timer.new()
	shieldTimer.connect("timeout", self, "_on_shield_timeout")
	shieldTimer.wait_time = 5.0
	add_child(shieldTimer)
	shieldTimer.start()
	get_node("Shield").show()
	isShieldOn = true

func _on_shield_timeout():
	shieldTimer.stop()
	shieldTimer.queue_free()
	get_node("Shield").hide()
	isShieldOn = false
	
