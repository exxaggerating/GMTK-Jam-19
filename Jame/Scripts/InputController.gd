extends Node

enum {DOWN, RELEASED}
enum Code {LONG, SHORT, DONE}

signal morse
signal character
signal key_changed

var begin = 0
var status = RELEASED
var actions = []

var keyboard_key
var joypad_key

var change = false

func is_held():
	return status == DOWN

func _input(event):
	if change:
		if event is InputEventKey:
			InputMap.action_erase_event("morse", keyboard_key)
			InputMap.action_add_event("morse", event)
			SceneSwitcher.save_game()
			emit_signal("key_changed")
		elif event is InputEventJoypadButton:
			InputMap.action_erase_event("morse", joypad_key)
			InputMap.action_add_event("morse", event)
			SceneSwitcher.save_game()
			emit_signal("key_changed")
	if event.is_action_pressed("morse"):
		begin = OS.get_ticks_msec()
		status = DOWN
	if event.is_action_released("morse"):
		if change:
			change = false
			return
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
	if status == RELEASED and actions.size() > 0:
		var elapsed = OS.get_ticks_msec() - begin
		if elapsed > 700:
			emit_signal("morse", Code, actions)
			actions = []
	
func change_key():
	for key in InputMap.get_action_list("morse"):
		if not key.as_text().begins_with("InputEventJoypadButton"):
			keyboard_key = key
		else:
			joypad_key = key
	change = true
