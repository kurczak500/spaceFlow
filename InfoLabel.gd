extends Node2D

var planetsNames = ["Mercury", "Wenus", "Earth", "Moon", "Mars", "Jupiter", "Saturn", "Uran", "Neptun", "Pluton", "Godot"]

func Init(currentPlanet):
	var infoLabel = get_node("InfoLabel")
	infoLabel.bbcode_text = """[center]You reached """+planetsNames[currentPlanet]+"""[/center]"""
	
	var timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.wait_time = 2.5
	add_child(timer)
	timer.start()
	
func _on_timer_timeout():
	queue_free()