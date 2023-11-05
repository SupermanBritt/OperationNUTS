extends CharacterBody2D


@export var max_speed : float = 3000.0
@export var jump_velocity: float = -6000.0
@export var gravity : float = 14000.0
@export var friction : float = 200.0
@export var acceleration : float = 500.0
var let_go_off_jump : bool = false
var isGliding : bool = false
@export var jump_hold_mult : float = .55
@export var gliding_mult_final : float = .1
var gliding_mult : float = 1
@export var max_gliding_speed : float = 4500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
 

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_pressed("jump") && velocity.y < -500 && let_go_off_jump == false:
			velocity.y += gravity * delta * jump_hold_mult
		else:
			velocity.y += gravity * delta * gliding_mult
		if Input.is_action_just_pressed("jump"):
			isGliding = true
			gliding_mult = gliding_mult_final
			velocity.y = 0
			max_speed = max_gliding_speed
		if Input.is_action_just_released("jump"):
			isGliding = false
			gliding_mult = 1
			max_speed = 3000.0
			
	if Input.is_action_just_released("jump"): 
		let_go_off_jump = true
	
	if is_on_floor():
		isGliding = false
		#Handle jump
		if Input.is_action_just_pressed("jump"):
			let_go_off_jump = false
			velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_held = Input.get_axis("move_left", "move_right")
	if abs(velocity.x + direction_held * acceleration) <= max_speed:
		velocity.x += direction_held * acceleration
	else:
		velocity.x = max_speed * direction_held

	# -1 moving left, 0 standing still, 1 moving right
	var direction_moving = 0

	if velocity.x != 0 && !direction_held:
		direction_moving = velocity.x / abs(velocity.x)
		if abs(velocity.x) - friction < 0:
			velocity.x = 0
		else:
			velocity.x -= friction * direction_moving
	print("x:", velocity.x, ", y:", velocity.y, ", max_speed:", max_speed)
	
	
	
	move_and_slide()
