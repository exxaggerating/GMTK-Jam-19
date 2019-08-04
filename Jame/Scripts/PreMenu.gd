extends Panel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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

func set_joypad(key):
	$Controls/Joypad.texture = button_index[key.button_index]

var o_pos = Vector2(90, 220)
var o_size = Vector2(480, 230)

var k_pos = Vector2(630, 220)
var k_size = Vector2(400, 230)

func _ready():
	$Indicator.rect_size = o_size
	$Indicator.rect_position = o_pos
	InputController.connect("morse", self, "_on_morse")
	var keys = InputMap.get_action_list("morse")
	for key in keys:
		if key is InputEventKey:
			$Controls/Keyboard.text = key.as_text()
		else:
			set_joypad(key)

func _on_morse(Code, actions):
	var matched = false
	match actions:
		[Code.LONG, Code.LONG, Code.LONG]:
			o_done = true
			matched = true
			$Indicator.rect_position = k_pos
			$Indicator.rect_size = k_size
		[Code.LONG, Code.SHORT, Code.LONG]:
			if o_done:
				SceneSwitcher.main_menu()
		_:
			if not matched:
				o_done = false
				$Indicator.rect_position = o_pos
				$Indicator.rect_size = o_size