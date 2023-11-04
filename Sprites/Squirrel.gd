extends CharacterBody2D


@export var speed : float = 3000.0
@export var max_speed : float = 3000.0
var jump_velocity: float = -6000.0
@export var gravity : float = 14000.0
@export var friction : float = 200.0
@export var acceleration : float = 500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_pressed("ui_accept") && velocity.y < 0:
			velocity.y += gravity * delta * .55
		else:
			velocity.y += gravity * delta


	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_held = Input.get_axis("move_left", "move_right")
	if abs(velocity.x + direction_held * acceleration) <= max_speed:
		velocity.x += direction_held * acceleration
	else:
		velocity.x = max_speed * direction_held
#	else:
#		velocity.x = move_toward(velocity.x, 0, speed)

	# -1 moving left, 0 standing still, 1 moving right
	var direction_moving = 0

	if velocity.x != 0 && !direction_held:
		direction_moving = velocity.x / abs(velocity.x)
		if abs(velocity.x) - friction < 0:
			velocity.x = 0
		else:
			velocity.x -= friction * direction_moving
	print("x:", velocity.x, ", y:", velocity.y)
	
	
	
	move_and_slide()
