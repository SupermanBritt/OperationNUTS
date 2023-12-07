extends Area2D

var hasBody = false

func enableOutline():
	get_node("AnimatedSprite2D").enableOutline()

func disableOutline():
	get_node("AnimatedSprite2D").disableOutline()

func grabBody():
	hasBody = true;

func dropBody():
	hasBody = false
	
func getHasBody():
	return hasBody
