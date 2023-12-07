extends Node

var currScene
var prevScene
# Called when the node enters the scene tree for the first time.
func _ready():
	currScene = "res://Scenes/main_menu.tscn"
	prevScene = "res://Scenes/main_menu.tscn"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
