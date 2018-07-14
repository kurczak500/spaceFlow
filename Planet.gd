extends Node2D

var velocity = Vector2(0, 0)
var REMOVE = -100

var planets = ["Mercury", "Wenus", "Earth", "Moon", "Mars", "Jupiter", "Saturn", "Uran", "Neptun", "Pluton", "IcePlanet"]

onready var player = get_node("..//Player")

var STARTX = 1400
var SIZEY = 720
	
func Init(planet):
	var node_object = get_node(planets[planet]).show()
	position = Vector2(STARTX, SIZEY/2)

func _process(delta):
	velocity = Vector2(player.speed * 0.0001, 0)
	position -= velocity

	if(position.x < REMOVE):
		self.queue_free()
