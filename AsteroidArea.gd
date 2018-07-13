extends Area2D

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	connect("area_entered",self,"area_entered")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func area_entered(body):
	print(body.get_name())