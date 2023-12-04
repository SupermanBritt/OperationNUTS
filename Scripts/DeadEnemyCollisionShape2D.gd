extends CollisionShape2D

func enableOutline():
	get_parent().get_node("AnimatedSprite2D").enableOutline()

func disableOutline():
	get_parent().get_node("AnimatedSprite2D").disableOutline()

func despawn():
	get_parent().queue_free()
