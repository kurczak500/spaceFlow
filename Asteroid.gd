extends Node2D

var velocity = Vector2(0, 0)

var STARTX = 1400
var SIZEY = 720
var REMOVE = -100

onready var player = get_node("..//Player")

func _ready():
	randomize()
	position = Vector2(STARTX, randi()%SIZEY)	

func _process(delta):
	var asteroidSpeed = player.speed * 0.0001
	if(player.speed == 0 && player.fuel == 0.0):
		asteroidSpeed = 8000.0 * 0.0001
		
	velocity = Vector2(asteroidSpeed, 0)
	position -= velocity

	if(position.x < REMOVE):
		self.queue_free()