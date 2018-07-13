extends Node2D

var asteroids = ["SmallAsteroid", "MediumAsteroid", "BigAsteroid"]
var velocity = Vector2(0, 0)

var STARTX = 1400
var SIZEY = 720

onready var player = get_node("..//Player")

func _ready():
	randomize()
	position = Vector2(STARTX, randi()%SIZEY)	
	
func Init(asteroid):
	var node_object = get_node(asteroids[asteroid]).show()

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	velocity = Vector2(player.speed * 0.1, 0)
	position -= velocity
