extends Area2D

var squirrelShouldDie = false
# Checks if the player has hit the flashlight
func _on_body_entered(_body):
	var bottom = $RayCastBottom.is_colliding() and $RayCastBottom.get_collider().is_in_group("player")
	var top = $RayCastTop.is_colliding() and $RayCastTop.get_collider().is_in_group("player")
	if  bottom or top:
		get_parent().get_parent().get_node("Squirrel").set_is_dead(true)
		squirrelShouldDie = true
	else:
		squirrelShouldDie = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if squirrelShouldDie:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
	var bodies = get_overlapping_bodies()
	for i in range(0,bodies.size()):
		_on_body_entered(bodies[i])
