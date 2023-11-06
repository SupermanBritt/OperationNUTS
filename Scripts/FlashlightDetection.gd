extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
#		print(str('Player has entered'))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var bodies = get_overlapping_bodies()
	for i in range(0,bodies.size()):
		_on_body_entered(bodies[i])
