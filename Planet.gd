extends Node2D

var planets = ["Mercury", "Wenus", "Earth", "Moon", "Mars", "Jupiter", "Saturn", "Uran", "Neptun", "Pluton", "IcePlanet"]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func Init(planet):
	var node_object = get_node(planets[planet]).show()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
