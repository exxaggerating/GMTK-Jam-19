extends Node

var current_level = 0
var max_level = 3
var completed_level = 0


var savegame = File.new()
var save_path = "user://savegame.bin"


func get_max_level():
	return max_level
	
func get_completed_level():
	return completed_level

func save_game():
	var keys_prop = InputMap.get_action_list("morse")
	var keys = {}
	for key in keys_prop:
		if key is InputEventJoypadButton:
			keys["button_index"] = key.get_button_index()
		else:
			keys["scancode"] = key.get_scancode()
	var save_data = {
		"level":completed_level,
		"keys":keys,
		"sfx":SoundController.sfx,
		"music":SoundController.music
		}
	savegame.open_encrypted_with_pass(save_path, File.WRITE, OS.get_unique_id())
	savegame.store_var(save_data)
	savegame.close()
	
func load_save():
	if savegame.file_exists(save_path):
		savegame.open_encrypted_with_pass(save_path, File.READ, OS.get_unique_id())
		var data = savegame.get_var()
		savegame.close()
		if data.size() <= 1:
			# This is an old and invalid save, we need a new one
			save_game()
			return
		completed_level = data["level"]
		SoundController.sfx = data["sfx"]
		SoundController.music = data["music"]
		SoundController.update_volume()
		
		for key in InputMap.get_action_list("morse"):
			InputMap.action_erase_event("morse", key)
		
		var j = InputEventJoypadButton.new()
		j.set_button_index(data["keys"]["button_index"])
		InputMap.action_add_event("morse", j)
		
		var k = InputEventKey.new()
		k.set_scancode(data["keys"]["scancode"])
		InputMap.action_add_event("morse", k)
	else:
		pre_menu()

func _ready():
	load_save()

func reload():
	get_tree().reload_current_scene()

func start_game():
	if completed_level == 0:
		# Cue Cutscene
		pass
	if completed_level >= max_level:
		current_level = max_level
		completed_level = max_level
	else:
		current_level = completed_level + 1
	load_current_level()
	
func load_level(i):
	current_level = i
	load_current_level()
	
func load_current_level():
	save_game()
	SoundController.change_to(SoundController.intense)
	get_tree().change_scene("res://Scenes/Level" + str(current_level) + ".tscn")

func next_level():
	completed_level += 1
	if current_level == max_level:
		SoundController.change_to(SoundController.credits)
		get_tree().change_scene("res://Scenes/Cutscene.tscn")
	else:
		current_level += 1
		load_current_level()
	
func main_menu():
	save_game()
	SoundController.change_to(SoundController.default)
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
func level_select():
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")

func pre_menu():
	get_tree().change_scene("res://Scenes/PreMenu.tscn")

func options():
	get_tree().change_scene("res://Scenes/Options.tscn")

func pause():
	pass