extends AnimatedSprite2D

func enableOutline():
	material.set_shader_parameter("enabled", true)
	print("its called!")

func disableOutline():
#	self.material_override.set_shader_parameter("enabled", false)
	material.set_shader_parameter("enabled", false)

func _process(_delta):
#	disableOutline()
	pass
