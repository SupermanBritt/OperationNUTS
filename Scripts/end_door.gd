extends Node2D

@onready var _animated_sprite = $AnimatedSprite2D
var open = false
var num_enemies
var goToNextLevel = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_animated_sprite.play("close")
	_animated_sprite.stop()
	var sum = 0
	for node in get_parent().get_children():
		if "enemy" in node.get_groups():
			sum += 1
	num_enemies = sum
	
func decrement_enemies():
	num_enemies -= 1
	if num_enemies <= 0:
		_animated_sprite.play("open")
		_animated_sprite.stop()
		open = true

func _process(delta):
	if goToNextLevel:
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
func _on_area_2d_body_entered(body):
	if open and body.is_in_group("player"):
		goToNextLevel = true
	else:
		goToNextLevel = false
		
