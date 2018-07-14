extends AnimatedSprite

func _ready():
	connect("animation_finished",self,"animation_finished")
	frame = 0		
	
func RunAnimation(type):
	if(type == 0):
		play("Collision")
	elif(type == 1):
		scale = Vector2(2.0, 2.0)
		play("Death")
	elif(type == 2):
		scale = Vector2(4.0, 4.0)
		play("Death")

func animation_finished():
	get_parent().queue_free()