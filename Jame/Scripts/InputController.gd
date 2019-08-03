extends Node

enum {DOWN, RELEASED}
enum Code {LONG, SHORT, DONE}

signal morse
signal character

var begin = 0
var status = RELEASED
var actions = []

var short_sound = load("res://Sounds/ShortMorse.wav")
var long_sound = load("res://Sounds/LongMorse.wav")

func play_sound(sound, volume=0, pitch=1):
	var player = AudioStreamPlayer.new()
	player.stream = sound
	self.add_child(player)
	player.volume_db = volume
	player.pitch_scale = pitch
	player.connect("finished", self, "kill_player", [player], CONNECT_ONESHOT)
	player.play()

func kill_player(player):
	self.remove_child(player)

func _ready():
	# TODO: Disable Mouse
	pass

func is_held():
	return status == DOWN

func _input(event):
	# Keydown
	if event.is_action_pressed("morse"):
		begin = OS.get_ticks_msec()
		status = DOWN
	if event.is_action_released("morse"):
		var end = OS.get_ticks_msec()
		var elapsed = end - begin
		begin = end
		if elapsed > 400:
			actions.append(Code.LONG)
			play_sound(long_sound)
			emit_signal("character", Code.LONG)
		else:
			actions.append(Code.SHORT)
			play_sound(short_sound)
			emit_signal("character", Code.SHORT)
		status = RELEASED
		
func _process(delta):
	if status == RELEASED:
		var elapsed = OS.get_ticks_msec() - begin
		if elapsed > 700:
			emit_signal("morse", Code, actions)
			actions = []
	
