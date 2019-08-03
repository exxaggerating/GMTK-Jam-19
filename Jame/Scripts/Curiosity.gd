extends KinematicBody2D


enum State {IDLE, MOVING}

const GRAVITY = 50.0
const WALK_ACCEL = 10.0
const MAX_SPEED = 50.0

var current_state = State.IDLE
var velocity = Vector2()

func _ready():
	$AnimationPlayer.play("IDLE")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	InputController.connect("morse", self, "_on_morse")

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	match current_state:
		State.MOVING:
			velocity.x += delta * WALK_ACCEL
			velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		State.IDLE:
			velocity.x = 0
	
	var collision_vector = move_and_slide(velocity, Vector2(0, -1))
	
	# Reset gravitational forces when touching the ground
	if collision_vector.y == 0:
		velocity.y = 0

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
