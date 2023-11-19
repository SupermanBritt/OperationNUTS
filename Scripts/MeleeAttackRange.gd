extends RayCast2D

func _on_body_entered(body):
	if body.is_in_group("enemy") && !(body.is_in_group("flashlight")):
		
#		body.get_node("AnimatedSprite2D").enableOutline()

# Called when the node enters the scene tree for the first time.
func _ready():
	target_position.x *= get_parent().direction_facing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	target_position.x *= get_parent().direction_facing
	if is_colliding():
		_on_body_entered(get_collider())
