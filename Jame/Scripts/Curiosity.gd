extends KinematicBody2D

signal acceleration

enum State {IDLE, MOVING}

const GRAVITY = 60.0
const WALK_ACCEL = 25.0
const MAX_SPEED = 50.0
const JUMP_POWER = -120

var current_state = State.IDLE
var velocity = Vector2()
var is_midair = true
var is_jumping = false
var direction = 1

func _ready():
	$AnimationPlayer.play("IDLE")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	InputController.connect("morse", self, "_on_morse")

func _physics_process(delta):
	if is_jumping && $AnimationPlayer.current_animation_position >= 1.0:
		velocity.y = JUMP_POWER
		is_jumping = false
		is_midair = true
	
	if is_midair:
		velocity.y += delta * GRAVITY
	else:
		velocity.y = 1
	
	match current_state:
		State.MOVING:
			velocity.x += delta * WALK_ACCEL * direction
			velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		State.IDLE:
			velocity.x = 0
	
	move_and_slide(velocity, Vector2(0, -1))
	
	# Reset gravitational forces when touching the ground
	if test_move(transform, Vector2(0, 1)):
		is_midair = false
	else:
		is_midair = true

func _on_animation_finished(animation):
	match current_state:
		State.IDLE:
			$AnimationPlayer.play("IDLE")
		State.MOVING:
			$AnimationPlayer.play("WALK")

func _on_morse(Code, actions):
	match actions:
		[Code.SHORT]:
			if !is_midair:
				$AnimationPlayer.play("JUMP")
				is_jumping = true
				SoundController.jump()
		[Code.SHORT, Code.SHORT]:
			if current_state == State.IDLE:
				current_state = State.MOVING
				$AudioStreamPlayer.play()
			else:
				$AudioStreamPlayer.stop()
				if $AnimationPlayer.current_animation == "WALK":
					$AnimationPlayer.play("IDLE")
				
				current_state = State.IDLE
			emit_signal("acceleration", State, current_state)
		[Code.LONG]:
			SoundController.turn()
			$Sprite.flip_h = !$Sprite.flip_h
			direction *= -1
			velocity.x *= -1
