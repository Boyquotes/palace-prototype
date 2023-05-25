extends CharacterBody2D

enum STATES {IDLE, RUNNING_START, RUNNING, RUNNING_END, JUMPING, LANDING}

const SPEED = 150.0
const ACCEL = 7.0
const DEACCEL = 15.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$AnimatedSprite2D.play("jump")
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("interact") and is_on_floor():
		$AnimatedSprite2D.play("punch")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerpf(velocity.x, direction * SPEED, ACCEL * delta)
	else:
		velocity.x = lerpf(velocity.x, 0, DEACCEL * delta)

	move_and_slide()
