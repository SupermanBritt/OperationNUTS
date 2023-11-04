extends CharacterBody2D

@export var gravity : float = 6000.0
@export var speed : float = 3000.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + speed * delta)
