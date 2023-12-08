extends Area2D

@export var susLimit = 500
@export var susIncrement = 45
@export var susDecrement = 5
var susValue = 0

signal suspicionValue(suspicionValue)

var squirrelShouldDie = false
## Checks if the player has hit the flashlight
#func _on_body_entered(_body):
	#var x = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#if squirrelShouldDie:
		#get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
	#var bodies = get_overlapping_bodies()
	if susValue > 0:
		susValue -= susDecrement
		if susValue < 0:
			susValue = 0
		emit_signal("suspicionValue", susValue)
		
	var bottom = $RayCastBottom.is_colliding() and $RayCastBottom.get_collider().is_in_group("player")
	var middle = $RayCastMiddle.is_colliding() and $RayCastMiddle.get_collider().is_in_group("player")
	var top = $RayCastTop.is_colliding() and $RayCastTop.get_collider().is_in_group("player")
	
	if  bottom or top or middle:
		susValue += susIncrement
		emit_signal("suspicionValue", susValue)
		if susValue > susLimit:
			get_parent().get_parent().get_node("Squirrel").set_is_dead(true)
			Global.goto_scene("res://Scenes/game_over.tscn")
		#else:
			#squirrelShouldDie = false
	#for i in range(0,bodies.size()):
		#_on_body_entered(bodies[i])


