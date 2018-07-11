extends Node2D

var velocity = Vector2( 0.0, 0.0 )
var lifes = 0
var thrust = 0
var fuel = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	lifes = get_parent().LIFES #get lifes from root
	fuel = get_parent().FUEL #get fuel from root

func _process(delta):
	if Input.is_action_just_released("ui_right"): #prawo - zwiekszamy thrust
		pass
	if Input.is_action_just_released("ui_left"): #lewo - zmniejszamy thrust
		pass
	if Input.is_action_just_released("ui_up"): #gora - przesuwamy w gore
		pass
	if Input.is_action_just_released("ui_down"): #dol - przesuwamy w dol
		pass
	
	#position += velocity