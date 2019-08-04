extends Control

var default = Vector2(145, 160)
var back = Vector2(245, 650)

var offset = 150

var current = 0
var max_selection = 3

var sfx = false
var music = false

func _ready():
	InputController.connect("morse", self, "action")

func advance():
	current = (current + 1) % (max_selection + 1)
	update()
		
func revert():
	current -= 1
	if current < 0:
		current = max_selection
	update()
	
func update():
	if current == max_selection:
		$Selection.rect_position = back
	else:
		$Selection.rect_position = default + Vector2(0, offset * current)

func hide_warning():
	$KeyChangeWarning.hide()

func hide_incdec():
	$IncDecDialogue.hide()
	SoundController.update_volume()

func select():
	match current:
		0:
			$KeyChangeWarning.show()
			InputController.connect("key_changed", self, "hide_warning", [], CONNECT_ONESHOT)
			InputController.change_key()
		1:
			$IncDecDialogue.show()
			sfx = true
		2:
			$IncDecDialogue.show()
			music = true
		3:
			SceneSwitcher.main_menu()
	
func action(Code, actions):
	match actions:
		[Code.SHORT]:
			if sfx:
				SoundController.sfx += 5.0
				sfx = false
				hide_incdec()
			elif music:
				SoundController.music += 5.0
				music = false
				hide_incdec()
			else:
				advance()
		[Code.SHORT, Code.SHORT]:
			if sfx:
				SoundController.sfx -= 5.0
				sfx = false
				hide_incdec()
			elif music:
				SoundController.music -= 5.0
				music = false
				hide_incdec()
			else:
				revert()
		[Code.LONG]:
			select()