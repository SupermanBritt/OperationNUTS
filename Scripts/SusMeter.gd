extends Polygon2D

func _ready():
	scale.x = 0

func _on_flashlight_suspicion_value(suspicionValue):
	scale.x = suspicionValue / 1000.0
