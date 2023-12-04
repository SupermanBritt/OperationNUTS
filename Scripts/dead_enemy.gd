extends CharacterBody2D

@export var gravity : float = 6000.0

#var preloadedSprite = preload("res://Sprites/dead_enemy.tscn")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

#func spawn(x, y):
#	var enemy = preloadedSprite.instance()
#	enemy.position.x = x
#	enemy.position.y = y
#	get_tree().current_scene.add_child(enemy)

func enableOutline():
	get_node("AnimatedSprite2D").enableOutline()

func disableOutline():
	get_node("AnimatedSprite2D").disableOutline()
