extends CharacterBody2D

var max_speed_final : float = 3000.0
@export var max_speed : float = max_speed_final
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
@export var wall_climbing_speed : float = 2000.0
@export var wall_jump_pushback : float = max_speed_final
var isClinging : bool = false
var wall_jump_timer : float = -10000
var direction_facing : float = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
 

func _physics_process(delta):
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_held = Input.get_axis("move_left", "move_right")
	var delta_time = Time.get_ticks_msec() - wall_jump_timer
	
	if direction_held:
		isClinging = false
		
	if delta_time > 250:
		if abs(velocity.x + direction_held * acceleration) <= max_speed:
			velocity.x += direction_held * acceleration
		else:
			velocity.x = max_speed * direction_held

	# -1 moving left, 0 standing still, 1 moving right
	var direction_moving = 0
	
	#Friction
	if velocity.x != 0:
		direction_moving = velocity.x / abs(velocity.x)
		if abs(velocity.x) - friction < 0:
			velocity.x = 0
		else:
			velocity.x -= friction * direction_moving
	
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_pressed("jump") && velocity.y < -500 && let_go_off_jump == false:
			velocity.y += gravity * delta * jump_hold_mult
		else:
			velocity.y += gravity * delta * gliding_mult
		if Input.is_action_just_pressed("jump") && !is_on_wall() && delta_time > 250:
			isGliding = true
			gliding_mult = gliding_mult_final
			velocity.y = 0
			max_speed = max_gliding_speed
		if Input.is_action_just_released("jump"):
			isGliding = false
			gliding_mult = 1
			max_speed = max_speed_final
			
	if Input.is_action_just_released("jump"): 
		let_go_off_jump = true
	
	if is_on_floor():
		isGliding = false
		max_speed = max_speed_final
		#Handle jump
		if Input.is_action_just_pressed("jump"):
			let_go_off_jump = false
			velocity.y = jump_velocity
	
	
	
	#Climbing
	if on_wall() == direction_held and direction_held:
		isClinging = true
	
	if !on_wall():
		isClinging = false

	if isClinging:
		if Input.is_action_pressed("move_up"):
			velocity.y = -1 * wall_climbing_speed
		elif Input.is_action_pressed("move_down"):
			velocity.y = wall_climbing_speed
		else:
			velocity.y = 0
	
	#Wall sliding/jumping
	if Input.is_action_just_pressed("jump") and isClinging:
		isClinging = false
		velocity.y = jump_velocity * 1.2
		velocity.x = wall_jump_pushback * -on_wall()
		wall_jump_timer = Time.get_ticks_msec()
	print("x:", velocity.x, ", y:", velocity.y, ", max_speed:", max_speed)
	
	
	
	move_and_slide()

func on_wall() -> float:
	if $RayCast2DTR.is_colliding() or $RayCast2DBR.is_colliding():
		return 1
	elif $RayCast2DTL.is_colliding() or $RayCast2DBL.is_colliding():
		return -1
	else:
		return 0

