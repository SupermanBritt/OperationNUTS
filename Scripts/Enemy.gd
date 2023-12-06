extends CharacterBody2D

@export var gravity : float = 6000.0
@export var speed : float = 750.0
@export var pathLength : float = 3000.0
@export var startDirection : int = 1
var currentX
var startingX
@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	startingX = get_position().x
	currentX = startingX
	velocity.x = speed
	if startDirection == -1:
		speed *= -1
	_animated_sprite.play("walkleft")

func enableOutline():
	get_node("AnimatedSprite2D").enableOutline()

func disableOutline():
	get_node("AnimatedSprite2D").disableOutline()


func _physics_process(delta):
	# Getting the current X position
	currentX = get_position().x
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#if $BounceHitWall.is_colliding():
	# Checking if the enemy has traveled the pathLength
	if abs(startingX-currentX) > pathLength or startDirection * currentX < startDirection * startingX or get_child(3).get_child(2).is_colliding():
		scale.x *= -1
		velocity.x *= -1
#		print("Scale is: ", scale.x)
	# Checking if the enemy has returned to the starting position
	#if :
		#scale.x *= -1
		#velocity.x *= -1
###		print("Scale is: ", scale.x)
	move_and_slide()
