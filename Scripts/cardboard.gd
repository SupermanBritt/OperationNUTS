extends Area2D

@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	_animated_sprite.play("empty")

var hasBody = false

func enableOutline():
	get_node("AnimatedSprite2D").enableOutline()

func disableOutline():
	get_node("AnimatedSprite2D").disableOutline()

func grabBody():
	hasBody = true
	_animated_sprite.play("fill")

func dropBody():
	hasBody = false
	
func getHasBody():
	return hasBody
