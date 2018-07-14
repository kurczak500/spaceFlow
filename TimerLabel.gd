extends Node2D

var timeTimer

func _ready():		
	timeTimer = Timer.new()
	timeTimer.connect("timeout", self, "_on_EndTime_timeout")
	timeTimer.wait_time = 61.0
	timeTimer.one_shot = true
	add_child(timeTimer)
	timeTimer.start()

func _process(delta):
	get_node("TimerLabel").bbcode_text = String(int(timeTimer.time_left))

func _on_EndTime_timeout():
	get_parent().TimeEnd()
	