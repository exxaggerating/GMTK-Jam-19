extends AudioStreamPlayer

var default = load("res://Sounds/Background/Space Loop.wav")
var intense = load("res://Sounds/Background/Andromeda Journey.wav")

var jump_sound = load("res://Sounds/Large Industrial Robot-SoundBible.com-1509415522.wav")
var turn_sound = load("res://Sounds/Robot Leg Moving-SoundBible.com-1391027677.wav")
var turn_sound2 = load("res://Sounds/Robot Leg Moving Short.wav")
var turn_sound3 = load("res://Sounds/Robot Leg Moving Short Alt.wav")

var dot = load("res://Sounds/ShortMorse.wav")
var dash = load("res://Sounds/LongMorse.wav")

var sfx = 0.0
var music = 0.0

func _ready():
	InputController.connect("character", self, "beep")
	
func update_volume():
	volume_db = music
	SceneSwitcher.save_game()

func beep(code):
	if code == InputController.Code.LONG:
		play_sound(dash, -10)
	else:
		play_sound(dot, -10)

func jump():
	play_sound(jump_sound, -10)
	
func turn():
	play_sound(turn_sound3, -17, 0.5)

func play_sound(sound, volume=0, pitch=1):
	var player = AudioStreamPlayer.new()
	player.stream = sound
	self.add_child(player)
	player.volume_db = volume + sfx
	player.pitch_scale = pitch
	player.connect("finished", self, "kill_player", [player], CONNECT_ONESHOT)
	player.play()

func kill_player(player):
	self.remove_child(player)

func change_to(sound):
	stop()
	stream = sound
	play()