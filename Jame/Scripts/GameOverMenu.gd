extends Control

var exit = false
var positions = [Vector2(167, 215), Vector2(167, 435)]
var select

func _ready():
	select = $Node2D2/Selection
	self.hide()

func _on_Tween_tween_completed(object, key):
	self.show()
	InputController.connect("morse", self, "_on_morse")
	
func advance():
	exit = !exit
	select.rect_position = positions[1] if exit else positions[0]
	
func select():
	if exit:
		SceneSwitcher.main_menu()
	else:
		SceneSwitcher.reload()

func _on_morse(Code, actions):
	match actions:
		[Code.SHORT]:
			advance()
		[Code.SHORT, Code.SHORT]:
			advance()
		[Code.LONG]:
			select()
