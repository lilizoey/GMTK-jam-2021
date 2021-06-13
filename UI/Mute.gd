extends Button

var muted = false

func _ready():
	connect("pressed", self, "_on_pressed")
	AudioServer.set_bus_mute(1, muted)

func _on_pressed():
	muted = not muted
	
	AudioServer.set_bus_mute(1, muted)
	if muted:
		modulate = Color(0.1, 0.1, 0.1)
	else:
		modulate = Color(1.0, 1.0, 1.0)
