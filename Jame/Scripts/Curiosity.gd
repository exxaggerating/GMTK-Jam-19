extends KinematicBody2D


enum State {IDLE, MOVING}

var current_state = State.IDLE

func _ready():
	$AnimationPlayer.play("IDLE")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	InputController.connect("morse", self, "_on_morse")

func _on_animation_finished(animation):
	match current_state:
		State.IDLE:
			$AnimationPlayer.play("IDLE")
		State.MOVING:
			$AnimationPlayer.play("WALK")

func _on_morse(Code, actions):
	match actions:
		[Code.SHORT]:
			$AnimationPlayer.play("JUMP")
		[Code.SHORT, Code.SHORT]:
			if current_state == State.IDLE:
				current_state = State.MOVING
			else:
				if $AnimationPlayer.current_animation == "WALK":
					$AnimationPlayer.play("IDLE")
				
				current_state = State.IDLE
