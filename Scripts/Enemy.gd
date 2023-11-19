extends CharacterBody2D

@export var gravity : float = 6000.0
@export var speed : float = 750.0
@export var pathLength : float = 3000.0
var currentX
var startingX

func _ready():
	startingX = get_position().x
	currentX = startingX
	velocity.x = speed
	scale.x = -1

func _physics_process(delta):
	# Getting the current X position
	currentX = get_position().x
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Checking if the enemy has traveled the pathLength
	if abs(startingX-currentX) >= pathLength:
		scale.x *= -1
		velocity.x = -1 * speed
#		print("Scale is: ", scale.x)
	
	# Checking if the enemy has returned to the starting position
	if currentX <= startingX:
		scale.x *= -1
		velocity.x = speed
#		print("Scale is: ", scale.x)
	
	move_and_slide()

#func _process(delta):
	#get_parent().set_progress(get_parent().get_progress() + speed * delta)
