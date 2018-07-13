extends AnimatedSprite

func _ready():
	connect("animation_finished",self,"animation_finished")
	frame = 0		
	
func RunAnimation(isCollision):
	if(isCollision):
		play("Collision")
	else:
		scale = Vector2(2.0, 2.0)
		play("Death")
	

func animation_finished():
	get_parent().queue_free()