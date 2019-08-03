extends Panel

var command = []
var init = 160
var next = init

var dot = load("res://Assets/img/Dot.png")
var dash = load("res://Assets/img/Dash.png")

var full_time = load("res://Assets/img/full_time.png")
var part_time = load("res://Assets/img/part_time.png")

var scale_x = 7
var scale_y = 130

var pos_x = 1094
var pos_y = 25

var scale = Vector2(10, 10)

var time = 0
var full_sprite

func _ready():
	InputController.connect("character", self, "_on_character")
	InputController.connect("morse", self, "_on_morse")
	full_sprite = $full_sprite

func _process(process_delta):
	if InputController.is_held():
		update_time(Vector2(scale_x, scale_y), Vector2(pos_x, pos_y))
	else:
		var now = OS.get_ticks_msec()
		var delta = now - time
		var factor = (1.0 - (delta / 700.0))
		print(factor)
		if factor < 0:
			factor = 0
		var size = scale_y * factor
		var scale = Vector2(scale_x, size)
		var position = Vector2(pos_x, pos_y + (scale_y - size))
		update_time(scale, position)
	
func update_time(scale, pos):
	self.remove_child(full_sprite)
	full_sprite = Sprite.new()
	full_sprite.texture = full_time
	full_sprite.position = pos
	full_sprite.scale = scale
	full_sprite.centered = false
	self.add_child_below_node($part_time, full_sprite)

func _on_morse(code, action):
	clear()
	$OverflowError.hide()
	command.clear()
	time = 0
	
func clear():
	for sprite in command:
		self.remove_child(sprite)
	next = init
	
func _on_character(code):
	time = OS.get_ticks_msec()
	if command.size() > 4:
		clear()
		$OverflowError.show()
	elif code == InputController.Code.SHORT:
		var s = Sprite.new()
		self.add_child(s)
		s.texture = dot
		s.scale = scale
		s.position = Vector2(next + 40, 90)
		command.append(s)
		next += 80
	else:
		var s = Sprite.new()
		self.add_child(s)
		s.texture = dash
		s.scale = scale
		s.position = Vector2(next + 80, 90)
		command.append(s)
		next += 160