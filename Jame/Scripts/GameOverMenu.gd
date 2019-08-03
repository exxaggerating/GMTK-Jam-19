extends Control

var exit = false
var positions = [Vector2(), Vector2()]

func _on_Tween_tween_completed(object, key):
	# Show Menu
	InputController.connect("morse", self, "_on_morse")
	
func advance():
	exit = !exit
	
	
func select():
	pass

func _on_morse(Code, actions):
	match actions:
		[Code.SHORT]:
			advance()
		[Code.SHORT, Code.SHORT]:
			advance()
		[Code.LONG]:
			select()
