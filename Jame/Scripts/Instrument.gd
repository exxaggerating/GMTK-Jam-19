extends Panel

var command = []
var init = 160
var next = init

var dot = load("res://Assets/img/Dot.png")
var dash = load("res://Assets/img/Dash.png")

var scale = Vector2(10, 10)

func _ready():
	InputController.connect("character", self, "_on_character")
	InputController.connect("morse", self, "_on_morse")
	
func _on_morse(code, action):
	clear()
	$OverflowError.hide()
	command.clear()
	
func clear():
	for sprite in command:
		self.remove_child(sprite)
	next = init

func _on_character(code):
	if command.size() > 4:
		clear()
		$OverflowError.show()
	elif code == InputController.Code.SHORT:
		var s = Sprite.new()
		self.add_child(s)
		s.texture = dot
		s.scale = scale
		s.position = Vector2(next + 40, 100)
		command.append(s)
		next += 80
	else:
		var s = Sprite.new()
		self.add_child(s)
		s.texture = dash
		s.scale = scale
		s.position = Vector2(next + 80, 100)
		command.append(s)
		next += 160