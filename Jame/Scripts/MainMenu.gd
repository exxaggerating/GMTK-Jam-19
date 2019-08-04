extends Control

var index1 = load("res://Styles/index1.tres")
var index4 = load("res://Styles/index4.tres")

var menu
var selection = 0
var menu_items 

# Called when the node enters the scene tree for the first time.
func _ready():
	InputController.connect("morse", self, "_on_morse")
	menu_items = [$StartGamePanel, $SelectLevelPanel, $OptionsPanel, $QuitPanel]
	if SceneSwitcher.completed_level != 0:
		$StartGame.text = "Continue"
		$SelectLevelPanel.set("custom_styles/panel", index4)
		menu = [0, 1, 2, 3]
	else:
		$StartGame.text = "Start Game"
		$SelectLevelPanel.set("custom_styles/panel", index1)
		menu = [0, 2, 3]

func update_selection():
	$Selection.rect_position.y = menu_items[menu[selection]].rect_position.y + 30
	
func forward():
	selection = (selection + 1) % menu.size()
	update_selection()

func backward():
	selection -= 1
	if selection < 0:
		selection = menu.size() - 1
	update_selection()

func select():
	match menu[selection]:
		0:
			SceneSwitcher.start_game()
		1:
			SceneSwitcher.level_select()
		2:
			SceneSwitcher.options()
		3:
			get_tree().quit()

func _on_morse(Code, actions):
	match actions:
		[Code.SHORT]:
			forward()
		[Code.LONG]:
			select()
		[Code.SHORT, Code.SHORT]:
			backward()
