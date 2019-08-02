extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Check if there is already a Game file
	var savefile_exists = true
	if savefile_exists:
		$StartGame.text = "Continue"
		$LevelSelect.disabled = false
	else:
		$StartGame.text = "Start Game"
		$LevelSelect.disabled = true

func _on_morse(Code, actions):
	match actions:
		[Code.SHORT]:
			$StartGame.text = "SHORT"
		[Code.LONG]:
			$StartGame.text = "LONG"
		[Code.SHORT, Code.SHORT]:
			$StartGame.text = "Start Game"
