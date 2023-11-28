extends Area2D

@export var susLimit = 1000
@export var susIncrement = 15
@export var susDecrement = 5
var susValue = 0

# Checks if the player has hit the flashlight
func _on_body_entered(_body):
	var bottom = $RayCastBottom.is_colliding() and $RayCastBottom.get_collider().is_in_group("player")
	var top = $RayCastTop.is_colliding() and $RayCastTop.get_collider().is_in_group("player")
	if  bottom or top:
		susIncrement += 15
		if susValue > susLimit:
			get_parent().get_parent().get_node("Squirrel").set_is_dead(true)
			await get_tree().create_timer(0.1).timeout
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var bodies = get_overlapping_bodies()
	print(susValue)
	if susValue > 0:
		susDecrement -= 5
	for i in range(0,bodies.size()):
		_on_body_entered(bodies[i])
