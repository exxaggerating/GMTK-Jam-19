extends Control

var levels
var max_selection

var y_spacing = 70
var x_spacing = 290

var x1 = 105
var y1 = 100

var current_selection = 0

var back_select_pos = Vector2(245, 473)
var index1 = load("res://Styles/index1.tres")

func _ready():
	InputController.connect("morse", self, "_on_morse")
	levels = SceneSwitcher.get_max_level()
	for i in range(levels + 1, 11):
		get_node("Background/Labels/Level" + str(i) + "Label").hide()
		get_node("Background/Panels/Level" + str(i) + "Panel").hide()
	max_selection = SceneSwitcher.get_completed_level() + 1 # Plus 1 for the Back button
	for i in range(max_selection + 1, levels + 1):
		get_node("Background/Panels/Level" + str(i) + "Panel").set("custom_styles/panel", index1)

func update_selection():
	$Background/Labels/Level9Label.text = str(current_selection)
	$Background/Labels/Level10Label.text = str(max_selection)
	if current_selection == max_selection:
		$Background/Selection.rect_position = back_select_pos
	else:
		$Background/Selection.rect_position = Vector2(
			x1 if current_selection < 5 else x1 + x_spacing,
			y1 + (y_spacing * current_selection) if current_selection < 5 else y1 + (y_spacing * (current_selection - 5))
		)
	
func _on_morse(Code, actions):
	match actions:
		[Code.SHORT]:
			current_selection = (current_selection + 1) % (max_selection + 1)
			update_selection()
		[Code.SHORT, Code.SHORT]:
			if current_selection == 0:
				current_selection = max_selection
			else:
				current_selection -= 1
			update_selection()
		[Code.LONG]:
			pass