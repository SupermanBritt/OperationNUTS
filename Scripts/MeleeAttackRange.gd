extends RayCast2D

@export var attackRange : float = 1200.0
var hasBody = false
var currentBody
var flag = true
var preloadedDeadEnemySprite = preload("res://Sprites/dead_enemy.tscn")

func _on_body_entered(body, x, y):
	if (body!=null) && body.is_in_group("enemy"):
		body.enableOutline()
		if Input.is_action_just_pressed("kill"):
			get_parent().callAttack()
			body.die(x, y)
	elif (body!=null) && body.is_in_group("interactable"):
		if (body.getHasBody()==false):
			body.enableOutline()
			if Input.is_action_just_pressed("kill") && get_parent().getHasBody():
				get_parent().callPuke()
				body.grabBody()
				body.disableOutline()
				get_parent().dropBody()
	elif (body!=null) && body.is_in_group("dead_enemy"):
		body.enableOutline()
		if Input.is_action_just_pressed("kill") && (get_parent().getHasBody()==false):
			get_parent().callEat()
			body.despawn()
			get_parent().grabBody()
	#else:
		#if Input.is_action_just_pressed("kill") && get_parent().getHasBody():
			#var deadenemy = preloadedDeadEnemySprite.instantiate()
			#deadenemy.position.x = get_parent().position.x + 1800 * sign(get_parent().velocity.x)
			#deadenemy.position.y = get_parent().position.y
			#get_tree().current_scene.add_child(deadenemy)
			#print(get_parent().position.x)
			#print(get_parent().position.y)
			#print("puked!")


# Called when the node enters the scene tree for the first time.
func _ready():
	target_position.x = attackRange * get_parent().direction_facing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_colliding() && get_collider() != null && !(get_collider().is_in_group("walls")):
		currentBody = get_collider()
		_on_body_entered(currentBody, get_collision_point().x, get_collision_point().y)
	elif Input.is_action_just_pressed("kill") && get_parent().getHasBody() && !get_parent().getInVent():
		var childrenCount = get_tree().get_current_scene().get_child_count()
		for i in childrenCount:
			var child = get_tree().get_current_scene().get_child(i)
			if child.is_in_group("enemy"):
				child.disableOutline()
			elif child.is_in_group("interactable"):
				child.disableOutline()
			elif child.is_in_group("dead_enemy"):
				child.disableOutline()
		get_parent().callPuke()
		var deadenemy = preloadedDeadEnemySprite.instantiate()
		#this is the place to change the spawning
		var deadBodySpawning = get_parent().get_node("DeadBodySpawningDetection")
		if(deadBodySpawning.isColliding()):
			deadenemy.position.x = deadBodySpawning.getCollisionPointX()
			deadenemy.position.y = deadBodySpawning.getCollisionPointY()
			get_tree().current_scene.add_child(deadenemy)
			get_parent().dropBody()
		else:
			deadenemy.position.x = deadBodySpawning.getPointX()
			deadenemy.position.y = deadBodySpawning.getPointY()
			get_tree().current_scene.add_child(deadenemy)
			get_parent().dropBody()
			#print(deadBodySpawning.getPointX())
		#deadenemy.position.x = get_parent().get_position().x + 2400 * sign(get_parent().velocity.x)
		#deadenemy.position.y = get_parent().get_position().y
		#get_tree().current_scene.add_child(deadenemy)
		#get_parent().dropBody()
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
	
