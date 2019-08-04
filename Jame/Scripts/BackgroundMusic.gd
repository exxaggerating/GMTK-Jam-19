extends AudioStreamPlayer

var default = load("res://Sounds/Background/Cosmic Messages.wav")
var intense = load("res://Sounds/Background/Andromeda Journey.wav")
var credits = load("res://Sounds/Background/Space Loop.wav")

var jump_sound = load("res://Sounds/Large Industrial Robot-SoundBible.com-1509415522.wav")
var turn_sound = load("res://Sounds/Robot Leg Moving-SoundBible.com-1391027677.wav")
var turn_sound2 = load("res://Sounds/Robot Leg Moving Short.wav")
var turn_sound3 = load("res://Sounds/Robot Leg Moving Short Alt.wav")

var dot = load("res://Sounds/ShortMorse.wav")
var dash = load("res://Sounds/LongMorse.wav")

var sfx = 0.0
var music = -15.0

var tween

func _ready():
	InputController.connect("character", self, "beep")
	tween = Tween.new()
	self.add_child(tween)
	
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

func faded(object, property, bind):
	stop()
	tween.disconnect("tweeen_completed", self, "faded")
	stream = bind
	play()
	remove_child(tween)
	tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "volume_db", -80, music, 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func change_to(sound):
	if sound != stream:
		tween.connect("tween_completed", self, "faded", [sound])
		tween.interpolate_property(self, "volume_db", music, -60, 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()