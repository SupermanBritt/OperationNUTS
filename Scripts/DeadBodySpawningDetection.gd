extends RayCast2D

func isColliding():
	print(is_colliding())
	return is_colliding()

func getCollisionPointX():
	return (get_collision_point().x)+(-900*get_parent().direction_facing)

func getCollisionPointY():
	return get_collision_point().y

func getPointX():
	return to_global(target_position).x+(-600*get_parent().direction_facing)

func getPointY():
	return to_global(target_position).y

# Called when the node enters the scene tree for the first time.
func _ready():
	target_position.x = target_position.x * get_parent().direction_facing


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
