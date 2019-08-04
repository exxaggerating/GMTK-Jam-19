extends Panel

var a = load("res://Assets/img/Controller/360_A.png")
var b = load("res://Assets/img/Controller/360_B.png")
var x = load("res://Assets/img/Controller/360_X.png")
var y = load("res://Assets/img/Controller/360_Y.png")

var d_left = load("res://Assets/img/Controller/360_Dpad_Left.png")
var d_right = load("res://Assets/img/Controller/360_Dpad_Right.png")
var d_down = load("res://Assets/img/Controller/360_Dpad_Down.png")
var d_up = load("res://Assets/img/Controller/360_Dpad_Up.png")

var back = load("res://Assets/img/Controller/360_Back_Alt.png")
var start = load("res://Assets/img/Controller/360_Start_Alt.png")

var lb = load("res://Assets/img/Controller/360_LB.png")
var lt = load("res://Assets/img/Controller/360_LT.png")
var rb = load("res://Assets/img/Controller/360_RB.png")
var rt = load("res://Assets/img/Controller/360_RT.png")

var l_stick = load("res://Assets/img/Controller/360_Left_Stick.png")
var r_stick = load("res://Assets/img/Controller/360_Right_Stick.png")

var button_index = [a, b, x, y, lb, rb, lt, rt, l_stick, r_stick, back, start, d_up, d_down, d_left, d_right]

var o_done = false

var control_indicator
var menu_indicator

func set_joypad(key):
	$ControlTutorial/Controls/Joypad.texture = button_index[key.button_index]

var o_pos = Vector2(90, 220)
var o_size = Vector2(480, 230)

var k_pos = Vector2(630, 220)
var k_size = Vector2(400, 230)

var exit_pos = Vector2(350, 520)
var cont_pos = Vector2(350, 640)
var understood_pos = Vector2(350, 760)

var menu_positons = [exit_pos, cont_pos, understood_pos]
var menu_possibilities = [0, 2]

var selection = 0

var index1 = load("res://Styles/index1.tres")
var index4 = load("res://Styles/index4.tres")

var understood_panel
var continue_panel

func _ready():
	control_indicator = $ControlTutorial/Indicator
	menu_indicator = $MenuTutorial/Indicator
	
	understood_panel = $MenuTutorial/Understood
	continue_panel = $MenuTutorial/Continue
	
	control_indicator.rect_size = o_size
	control_indicator.rect_position = o_pos
	
	InputController.connect("morse", self, "_on_morse")
	
	var keys = InputMap.get_action_list("morse")
	for key in keys:
		if key is InputEventKey:
			$ControlTutorial/Controls/Keyboard.text = key.as_text()
		else:
			set_joypad(key)

func _on_morse(Code, actions):
	var matched = false
	match actions:
		[Code.LONG, Code.LONG, Code.LONG]:
			o_done = true
			matched = true
			control_indicator.rect_position = k_pos
			control_indicator.rect_size = k_size
		[Code.LONG, Code.SHORT, Code.LONG]:
			if o_done:
				InputController.disconnect("morse", self, "_on_morse")
				$ControlTutorial.hide()
				$MenuTutorial.show()
				InputController.connect("morse", self, "_on_morse_menu")
				return
		_:
			if not matched:
				o_done = false
				control_indicator.rect_position = o_pos
				control_indicator.rect_size = o_size

func update_selection():
	menu_indicator.rect_position = menu_positons[menu_possibilities[selection]]

func advance():
	selection = (selection + 1) % 2
	update_selection()
	
func reverse():
	selection -= 1
	if selection < 0:
		selection = 1
	update_selection()

func select():
	match menu_possibilities[selection]:
		0:
			get_tree().quit()
		1:
			SceneSwitcher.main_menu()
		2:
			menu_possibilities = [0, 1]
			understood_panel.set("custom_styles/panel", index1)
			update_selection()
			continue_panel.set("custom_styles/panel", index4)

func _on_morse_menu(Code, actions):
	match actions:
		[Code.SHORT]:
			advance()
		[Code.SHORT, Code.SHORT]:
			reverse()
		[Code.LONG]:
			select()