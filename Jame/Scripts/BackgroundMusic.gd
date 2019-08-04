extends AudioStreamPlayer

var default = load("res://Sounds/Background/Space Loop.wav")
var intense = load("res://Sounds/Background/Andromeda Journey.wav")

func change_to(sound):
	stop()
	stream = sound
	play()