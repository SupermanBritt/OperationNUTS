extends Area2D


# Checks if the player has hit the flashlight
func _on_body_entered(_body):
	if $RayCastBottom.get_collider().is_in_group("player") or $RayCastTop.get_collider().is_in_group("player"):
		get_parent().get_parent().get_node("Squirrel").set_is_dead(true)
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var bodies = get_overlapping_bodies()
	for i in range(0,bodies.size()):
		_on_body_entered(bodies[i])
