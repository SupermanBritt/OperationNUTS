extends Area2D

var preloadedSprite = preload("res://Sprites/dead_enemy.tscn")

# Checks if the player has hit the enemy
func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.goto_scene("res://Scenes/game_over.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var bodies = get_overlapping_bodies()
	for i in range(0,bodies.size()):
		_on_body_entered(bodies[i])

func die(x, y):
	var deadenemy = preloadedSprite.instantiate()
	if get_parent().speed == 0:
		deadenemy.position.x = x + 900 * sign(get_parent().startDirection)
	else:
		deadenemy.position.x = x + 900 * sign(get_parent().velocity.x)
	deadenemy.position.y = y - 200
	get_tree().current_scene.add_child(deadenemy)
	get_parent().get_parent().get_node("end_door").decrement_enemies()
	get_parent().queue_free()

func enableOutline():
	get_parent().enableOutline()

func disableOutline():
	get_parent().disableOutline()
