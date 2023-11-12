extends Area2D

# Checks if the player has hit the enemy
func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var bodies = get_overlapping_bodies()
	for i in range(0,bodies.size()):
		_on_body_entered(bodies[i])
