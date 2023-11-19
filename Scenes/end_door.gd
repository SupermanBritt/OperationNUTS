extends Node2D

@onready var _animated_sprite = $AnimatedSprite2D
var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_animated_sprite.play("close")
	_animated_sprite.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("debug"):
		_animated_sprite.play("open")
		_animated_sprite.stop()
		open = true
	


func _on_area_2d_body_entered(body):
	if open and body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
		
