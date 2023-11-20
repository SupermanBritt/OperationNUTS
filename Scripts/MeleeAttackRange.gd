extends RayCast2D

@export var attackRange : float = 1200.0

func _on_body_entered(body, x, y):
	print(body)
	if body.is_in_group("enemy"):
		print("enemy!")
		body.die(x, y)
#		body.get_node("AnimatedSprite2D").enableOutline()

# Called when the node enters the scene tree for the first time.
func _ready():
	target_position.x = attackRange * get_parent().direction_facing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print("running")
	print("positionx:", target_position.x)
	target_position.x = attackRange * get_parent().direction_facing
	if is_colliding():
		print("collided!")
		_on_body_entered(get_collider(), get_collision_point().x, get_collision_point().y)
