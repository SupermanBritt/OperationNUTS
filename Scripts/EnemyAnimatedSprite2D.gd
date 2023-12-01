extends AnimatedSprite2D

func enableOutline():
	material.set_shader_parameter("enabled", true)

func disableOutline():
	material.set_shader_parameter("enabled", false)

func _process(_delta):
#	disableOutline()
	pass
