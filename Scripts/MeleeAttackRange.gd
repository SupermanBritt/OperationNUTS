extends RayCast2D

@export var attackRange : float = 1200.0

func _on_body_entered(body, x, y):
	if body.is_in_group("enemy"):
		body.enableOutline()
#Call a function and have the enemy always call a function to turn off the highlight so that it is off as soon as it leave the range
		if Input.is_action_just_pressed("kill"):
			body.die(x, y)

# Called when the node enters the scene tree for the first time.
func _ready():
	target_position.x = attackRange * get_parent().direction_facing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	target_position.x = attackRange * get_parent().direction_facing
	if is_colliding():
		_on_body_entered(get_collider(), get_collision_point().x, get_collision_point().y)
