extends Control

var index1 = load("res://Styles/index1.tres")
var index4 = load("res://Styles/index4.tres")

var menu
var selection = 0
var menu_items 

# Called when the node enters the scene tree for the first time.
func _ready():
	# Check if there is already a Game file
	menu_items = [$Panel, $Panel2, $Panel3]
	var savefile_exists = false
	if savefile_exists:
		$StartGame.text = "Continue"
		$Panel2.set("custom_styles/panel", index4)
		menu = [0, 1, 2]
	else:
		$StartGame.text = "Start Game"
		$Panel2.set("custom_styles/panel", index1)
		menu = [0, 2]
	var bg = ButtonGroup.new()

func update_selection():
	$Selection.rect_position.y = menu_items[menu[selection]].rect_position.y + 20
	
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
			# Load the next/first Level scene
			pass
		1:
			# Load select level scene
			pass
		2:
			get_tree().quit()

func _on_morse(Code, actions):
	match actions:
		[Code.SHORT]:
			forward()
		[Code.LONG]:
			select()
		[Code.SHORT, Code.SHORT]:
			backward()
