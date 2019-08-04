extends Node

enum {DOWN, RELEASED}
enum Code {LONG, SHORT, DONE}

signal morse
signal character

var begin = 0
var status = RELEASED
var actions = []

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
			emit_signal("character", Code.LONG)
		else:
			actions.append(Code.SHORT)
			emit_signal("character", Code.SHORT)
		status = RELEASED
		
func _process(delta):
	if status == RELEASED:
		var elapsed = OS.get_ticks_msec() - begin
		if elapsed > 700:
			emit_signal("morse", Code, actions)
			actions = []
	
