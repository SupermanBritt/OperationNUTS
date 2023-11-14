extends CharacterBody2D

var max_speed_final : float = 3000.0
@export var max_speed : float = max_speed_final
@export var jump_velocity: float = -6000.0
@export var gravity : float = 14000.0
@export var friction : float = 200.0
@export var acceleration : float = 500.0
var let_go_off_jump : bool = false
var isGliding : bool = false
@export var jump_hold_mult : float = .55
@export var gliding_mult_final : float = .1
var gliding_mult : float = 1
@export var max_gliding_speed : float = 4500.0
@export var wall_climbing_speed : float = 3500.0
@export var wall_jump_pushback : float = max_speed_final
var isClinging : bool = false
var wall_jump_timer : float = -10000
var direction_facing : float = 1
@export var wall_jump_delay : float = 250
var current_tilemap: TileMap
var raycastLength = 10
var currVent = []
var inVent = false


@onready var _animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
 
func _ready():
	reset_camera()


func _process(_delta):
	var direction_held = Input.get_axis("move_left", "move_right") 
	if sign(velocity.x) == 1 and direction_held == 1 and is_on_floor():
		_animated_sprite.play("run_right")
	elif sign(velocity.x) == -1 and direction_held == -1 and is_on_floor():
		_animated_sprite.play("run_left")
	elif !is_on_floor() and isGliding and direction_facing == 1:
		_animated_sprite.play("glide_right")
	elif !is_on_floor() and isGliding and direction_facing == -1:
		_animated_sprite.play("glide_left")
	elif !is_on_floor() and velocity.y < 0 and direction_facing == 1 and !isGliding:
		_animated_sprite.play("jump_up_right")
	elif !is_on_floor() and velocity.y > 0 and direction_facing == 1 and !isGliding:
		_animated_sprite.play("jump_down_right")
	elif !is_on_floor() and velocity.y < 0 and direction_facing == -1 and !isGliding:
		_animated_sprite.play("jump_up_left")
	elif !is_on_floor() and velocity.y > 0 and direction_facing == -1 and !isGliding:
		_animated_sprite.play("jump_down_left")
	elif direction_held == 1 and is_on_floor():
		_animated_sprite.play("run_right")
	elif direction_held == -1 and is_on_floor():
		_animated_sprite.play("run_left")
	elif direction_facing == -1 and is_on_floor(): #Have these at the end
		_animated_sprite.play("idle_left")
	elif direction_facing == 1 and is_on_floor(): 
		_animated_sprite.play("idle_right")
	else:
		_animated_sprite.stop()
		
func _physics_process(delta):		
	# Get the input direction and handle the movement/deceleration.
	var direction_held = Input.get_axis("move_left", "move_right")
	var delta_time = Time.get_ticks_msec() - wall_jump_timer
	
	if direction_held:
		direction_facing = direction_held
		isClinging = false
		
	if delta_time > wall_jump_delay:
		if abs(velocity.x + direction_held * acceleration) <= max_speed:
			velocity.x += direction_held * acceleration
		else:
			velocity.x = max_speed * direction_held
	
	#Friction
	if velocity.x != 0:
		if abs(velocity.x) - friction < 0:
			velocity.x = 0
		else:
			velocity.x -= friction * sign(velocity.x)
	
	if Input.is_action_just_pressed("debug"):
		get_tree().change_scene_to_file("res://Scenes/testing2.tscn")
	
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_pressed("jump") && velocity.y < -500 && let_go_off_jump == false:
			velocity.y += gravity * delta * jump_hold_mult
		else:
			velocity.y += gravity * delta * gliding_mult
			
		if Input.is_action_just_pressed("jump") && !on_wall() && delta_time > wall_jump_delay:
			isGliding = true
			velocity.y = 0
		if Input.is_action_just_released("jump"):
			isGliding = false

		if isGliding:
			gliding_mult = gliding_mult_final
			max_speed = max_gliding_speed
		else:
			gliding_mult = 1
			max_speed = max_speed_final
			
	if Input.is_action_just_released("jump"): 
		let_go_off_jump = true
	
	if is_on_floor():
		isGliding = false
		max_speed = max_speed_final
		#Handle jump
		if Input.is_action_just_pressed("jump"):
			let_go_off_jump = false
			velocity.y = jump_velocity
	
	
	
	#Climbing
	if on_wall() == direction_held and direction_held:
		isClinging = true
	
	if !on_wall():
		isClinging = false

	if isClinging:
		if Input.is_action_pressed("move_up"):
			velocity.y = -1 * wall_climbing_speed
		elif Input.is_action_pressed("move_down"):
			velocity.y = wall_climbing_speed
		else:
			velocity.y = 0
	
	#Wall sliding/jumping
	if Input.is_action_just_pressed("jump") and isClinging:
		isClinging = false
		velocity.y = jump_velocity * 1.2
		velocity.x = wall_jump_pushback * -on_wall()
		wall_jump_timer = Time.get_ticks_msec()
	#print("x:", velocity.x, ", y:", velocity.y, ", max_speed:", max_speed)
	
	if Input.is_action_just_pressed("vent") and currVent.size() != 0:
		vent()
	
	reset()
	move_and_slide()

func on_wall() -> float:
	if $RayCast2DRight.is_colliding():
		return 1
	elif $RayCast2DLeft.is_colliding():
		return -1
	else:
		return 0
		
func reset_camera():
	var polygon = self.get_parent().get_node("CameraBorder")

	var vertices = polygon.get_polygon()
	$Camera2D.limit_bottom = vertices[0].y
	$Camera2D.limit_top = vertices[0].y
	$Camera2D.limit_right = vertices[0].x
	$Camera2D.limit_left = vertices[0].x
	for vertex in vertices:
		if vertex.x < $Camera2D.limit_left:
			$Camera2D.limit_left = vertex.x
		if vertex.x > $Camera2D.limit_right:
			$Camera2D.limit_right = vertex.x
		if vertex.y < $Camera2D.limit_top:
			$Camera2D.limit_top = vertex.y
		if vertex.y > $Camera2D.limit_bottom:
			$Camera2D.limit_bottom = vertex.y

func _on_terrain_detector_terrain_entered(terrain_type, tile_coords, c_map):
	if terrain_type < 5 and terrain_type >= 1:
		current_tilemap = c_map
		currVent = [terrain_type, tile_coords]

func _on_terrain_detector_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	currVent = []
				
func vent():
	var ventDir = currVent[0]
	var map = currVent[1]
	var ventLocation = map * 600
	if Input.is_action_just_pressed("vent"):
		inVent = !inVent
		match ventDir:
			1: #Left
				position.y = ventLocation.y + sign(ventLocation.y) * -300
				map.x -= 1
				var distance = 1
				while current_tilemap.get_cell_tile_data(0, map) != null and current_tilemap.get_cell_tile_data(0, map).get_custom_data("tileType") == 0:
					map.x -= 1
					distance += 1
				position.x = map.x * 600 + 300
				if inVent:
					$Camera2D.limit_left -= distance * 600
				else:
					reset_camera()
			2: #Top
				position.x = ventLocation.x + sign(ventLocation.x) * -300
				map.y -= 1
				while current_tilemap.get_cell_tile_data(0, map) != null and current_tilemap.get_cell_tile_data(0, map).get_custom_data("tileType") == 0:
					map.y -= 1
				position.y = map.y * 600 + 300
				if inVent:
					$Camera2D.limit_top -= 1200
				else:
					reset_camera()
			3: #Right
				position.y = ventLocation.y + sign(ventLocation.y) * -300
				map.x += 1
				while current_tilemap.get_cell_tile_data(0, map) != null and current_tilemap.get_cell_tile_data(0, map).get_custom_data("tileType") == 0:
					map.x += 1
				position.x = map.x * 600 + 300
				if inVent:
					$Camera2D.limit_right += 1200
				else:
					reset_camera()
			4: #Bottom
				position.x = ventLocation.x + sign(ventLocation.x) * -300
				map.y += 1
				while current_tilemap.get_cell_tile_data(0, map) != null and current_tilemap.get_cell_tile_data(0, map).get_custom_data("tileType") == 0:
					map.y += 1
				position.y = map.y * 600 + 100
				if inVent:
					$Camera2D.limit_bottom += 1200
				else:
					reset_camera()
		

		
#func vent_check():
#	var ventDir = 0
#	var ventLocation
#	var output = vent_collision()
#	if output.size() != 0:
#		ventLocation = output[0]
#		ventDir = output[1]
#		var map = ventLocation / 600
#		if Input.is_action_just_pressed("vent"):
#			match ventDir:
#				1: #Left
#					position.y = ventLocation.y + sign(ventLocation.y) * -300
#					map.x -= 1
#					while current_tilemap.get_cell_tile_data(0, map) != null and current_tilemap.get_cell_tile_data(0, map).get_custom_data("tileType") == 0:
#						map.x -= 1
#					position.x = map.x * 600 + 300
#				2: #Top
#					position.x = ventLocation.x + sign(ventLocation.x) * -300
#					map.y -= 1
#					while current_tilemap.get_cell_tile_data(0, map) != null and current_tilemap.get_cell_tile_data(0, map).get_custom_data("tileType") == 0:
#						map.y -= 1
#					position.y = map.y * 600 + 300
#				3: #Right
#					position.y = ventLocation.y + sign(ventLocation.y) * -300
#					map.x += 1
#					while current_tilemap.get_cell_tile_data(0, map) != null and current_tilemap.get_cell_tile_data(0, map).get_custom_data("tileType") == 0:
#						map.x += 1
#					position.x = map.x * 600 + 300
#				4: #Bottom
#					position.x = ventLocation.x + sign(ventLocation.x) * -300
#					map.y += 1
#					while current_tilemap.get_cell_tile_data(0, map) != null and current_tilemap.get_cell_tile_data(0, map).get_custom_data("tileType") == 0:
#						map.y += 1
#					position.y = map.y * 600 + 100
#
##(ventLocation, ventDir)
#func vent_collision() -> Array:
##	var i = 0
#	for node in self.get_children():
#		var output = []
#		if node.get_class() == "RayCast2D":
##			i += 1
##			print(i)
#			if node.is_colliding():
#				current_tilemap = node.get_collider()
#				var collision_point = node.get_collision_point()
#				var map = current_tilemap.local_to_map(collision_point)
#				var tiledata = current_tilemap.get_cell_tile_data(0, map)
#				var ventDir
#				if tiledata != null:
#					ventDir = tiledata.get_custom_data("tileType")
#				else:
#					var dir = sign(node.get_target_position())
#					map += dir as Vector2i
#					tiledata = current_tilemap.get_cell_tile_data(0, map)
#					ventDir = tiledata.get_custom_data("tileType")
#				if (ventDir > 0 and ventDir < 5):
#					var ventLocation = map * 600
#					output.append(ventLocation)
#					output.append(ventDir)
#					return output
#	return []
			
			
func reset():
	if Input.is_action_just_pressed("reset") and Input.is_action_pressed("vent"):
		position.x = 26400
		position.y = -1500
	elif Input.is_action_just_pressed("reset"):
		position.x = -11400
		position.y = -1500



