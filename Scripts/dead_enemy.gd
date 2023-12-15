extends CharacterBody2D

@export var gravity : float = 6000.0
var direction_facing
@onready var _animated_sprite = $AnimatedSprite2D
#var preloadedSprite = preload("res://Sprites/dead_enemy.tscn")

func _ready():
	if sign(direction_facing) == -1:
		if direction_facing == -1:
			_animated_sprite.play("die_left")
		elif direction_facing == -2:
			_animated_sprite.play("dead_left")
	elif sign(direction_facing) == 1:
		if direction_facing == 1:
			_animated_sprite.play("die_right")
		elif direction_facing == 2:
			_animated_sprite.play("dead_right")
		_animated_sprite.get_child(0).position.x += 900
		$CollisionShape2D.position.x += 900
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

#func spawn(x, y):
#	var enemy = preloadedSprite.instance()
#	enemy.position.x = x
#	enemy.position.y = y
#	get_tree().current_scene.add_child(enemy)

func enableOutline():
	get_node("AnimatedSprite2D").enableOutline()

func disableOutline():
	get_node("AnimatedSprite2D").disableOutline()

func despawn():
	queue_free()
