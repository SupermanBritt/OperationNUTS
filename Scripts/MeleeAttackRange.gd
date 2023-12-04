extends RayCast2D

@export var attackRange : float = 1200.0
var hasBody = false

func _on_body_entered(body, x, y):
	if body.is_in_group("enemy"):
		body.enableOutline()
		if Input.is_action_just_pressed("kill"):
			body.die(x, y)
	elif body.is_in_group("interactable"):
		body.enableOutline()
	elif body.is_in_group("dead_enemy"):
		body.enableOutline()

# Called when the node enters the scene tree for the first time.
func _ready():
	target_position.x = attackRange * get_parent().direction_facing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	target_position.x = attackRange * get_parent().direction_facing
	if is_colliding():
		_on_body_entered(get_collider(), get_collision_point().x, get_collision_point().y)
	else:
		var childrenCount = get_tree().get_current_scene().get_child_count()
		for i in childrenCount:
			var child = get_tree().get_current_scene().get_child(i)
			if child.is_in_group("enemy"):
				child.disableOutline()
			elif child.is_in_group("interactable"):
				child.disableOutline()
			elif child.is_in_group("dead_enemy"):
				child.disableOutline()
