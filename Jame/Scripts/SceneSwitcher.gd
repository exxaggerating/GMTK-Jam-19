extends Node

var current_level = 0
var max_level = 5
var completed_level = 0


var save_data = {"level":completed_level}
var savegame = File.new()
var save_path = "user://savegame.bin"

func get_max_level():
	return max_level
	
func get_completed_level():
	return completed_level

func save_game():
    savegame.open_encrypted_with_pass(save_path, File.WRITE, OS.get_unique_id())
    savegame.store_var(save_data)
    savegame.close()
	
func load_save():
	if savegame.file_exists(save_path):
		savegame.open_encrypted_with_pass(save_path, File.READ, OS.get_unique_id())
		var data = savegame.get_var()
		savegame.close()
		completed_level = data["level"]

func _ready():
	load_save()

func reload():
	get_tree().reload_current_scene()

func start_game():
	if completed_level == 0:
		# Cue Cutscene
		pass
	current_level = 1
	load_current_level()
	
func load_level(i):
	current_level = i
	load_current_level()
	
func load_current_level():
	save_game()
	BackgroundMusic.change_to(BackgroundMusic.intense)
	get_tree().change_scene("res://Scenes/Level" + str(current_level) + ".tscn")

func next_level():
	completed_level += 1
	if current_level == max_level:
		# Load final Cutscene, switch to the Credits and land in the main menu
		pass
	else:
		current_level += 1
		load_current_level()
	
func main_menu():
	BackgroundMusic.change_to(BackgroundMusic.default)
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
func level_select():
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")

func pause():
	pass