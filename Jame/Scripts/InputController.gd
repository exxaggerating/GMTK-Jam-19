extends Node

enum {DOWN, RELEASED}
enum Code {LONG, SHORT, DONE}

signal morse

var begin = 0
var status = RELEASED
var actions = []

func _ready():
	# TODO: Disable Mouse
	pass

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
		else:
			actions.append(Code.SHORT)
		status = RELEASED
		
func _process(delta):
	if status == RELEASED:
		var elapsed = OS.get_ticks_msec() - begin
		if elapsed > 700:
			emit_signal("morse", Code, actions)
			actions = []
	
