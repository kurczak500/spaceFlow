extends Area2D

func _ready():
	connect("area_entered",self,"area_entered")

func area_entered(body):
	print(body.get_name())
	if "Player" in body.get_name():
		get_parent().queue_free()