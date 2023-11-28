extends Area2D

@export var susLimit = 1000
@export var susIncrement = 13
@export var susDecrement = 5
var susValue = 0

signal suspicionValue(suspicionValue)

# Checks if the player has hit the flashlight
func _on_body_entered(_body):
	var bottom = $RayCastBottom.is_colliding() and $RayCastBottom.get_collider().is_in_group("player")
	var middle = $RayCastMiddle.is_colliding() and $RayCastMiddle.get_collider().is_in_group("player")
	var top = $RayCastTop.is_colliding() and $RayCastTop.get_collider().is_in_group("player")
	if  bottom or top or middle:
		susValue += susIncrement
		emit_signal("suspicionValue", susValue)
		if susValue > susLimit:
			get_parent().get_parent().get_node("Squirrel").set_is_dead(true)
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var bodies = get_overlapping_bodies()
	if susValue > 0:
		susValue -= susDecrement
		emit_signal("suspicionValue", susValue)
	for i in range(0,bodies.size()):
		_on_body_entered(bodies[i])


