extends Area2D

func _ready():
	connect("area_entered",self,"area_entered")

func area_entered(body):
	if "Player" in body.get_name():
		get_parent().queue_free()