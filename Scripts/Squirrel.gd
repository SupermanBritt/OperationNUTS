extends CharacterBody2D

var hasBody = false;
var max_speed_final : float = 3500.0
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
@export var inVent : bool = false
#var inVent = false
var in_debug_mode = false
var spawn_pos
var is_dead = false
var allow_debug = true
var prevDirectionFacing = direction_facing
var baseTailPos
var direction_held
var direction_held_y
var direction_facing_y = -1
var prevDirectionFacing_y = direction_facing_y

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _tail_sprite = $TailAnimatedSprite

signal venting

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
 
func _ready():
	reset_camera()
	current_tilemap = self.get_parent().get_node("TileMap")
	spawn_pos = position
	baseTailPos = get_child(0).position


func _process(_delta):
	squirrel_animation()
	#scale.x = direction_held
	#_animated_sprite.play("run_right")
	tail_animation()

func tail_animation():
	if velocity.x or velocity.y:
		_tail_sprite.play("moving")
	else:
		_tail_sprite.stop()

func squirrel_animation():
	if is_dead:
		_animated_sprite.stop()
	#elif isClinging and direction_facing == 1 and sign(velocity.y) == -1:
		#_animated_sprite.play("climb_right_up")
	#elif isClinging and direction_facing == 1 and sign(velocity.y) == 1:
		#_animated_sprite.play("climb_right_down")
	#elif isClinging and direction_facing == -1 and sign(velocity.y) == -1:
		#_animated_sprite.play("climb_left_up")
	#elif isClinging and direction_facing == -1 and sign(velocity.y) == 1:
		#_animated_sprite.play("climb_left_down")
	elif direction_held_y and isClinging:
		_animated_sprite.play("run")
	elif !direction_held_y and isClinging:
		_animated_sprite.play("climb_idle")
	elif sign(velocity.x) and direction_held and is_on_floor():
		_animated_sprite.play("run")
	elif !is_on_floor() and isGliding:
		_animated_sprite.play("glide")
	elif !is_on_floor() and velocity.y < 0 and !isGliding:
		_animated_sprite.play("jump_up")
	elif !is_on_floor() and velocity.y > 0 and !isGliding:
		_animated_sprite.play("jump_down")
	elif is_on_floor(): 
		_animated_sprite.play("idle")
	else:
		_animated_sprite.stop()
	
func _physics_process(delta):		
	# Get the input direction and handle the movement/deceleration.
	direction_held_y = Input.get_axis("move_up", "move_down") 
	direction_held = Input.get_axis("move_left", "move_right")
	var delta_time = Time.get_ticks_msec() - wall_jump_timer
	
	if direction_held:
		if prevDirectionFacing != direction_held:
			scale.x = -1
		direction_facing = direction_held
		prevDirectionFacing = direction_facing	
		if direction_held != direction_facing:
			isClinging = false
	
	
	if direction_held_y:
		if prevDirectionFacing_y != direction_held_y:
			scale.y *= -1
		direction_facing_y = direction_held_y
		prevDirectionFacing_y = direction_facing_y
	
	if !isClinging:
		if direction_facing_y == 1:
			scale.y *= -1
		direction_facing_y = -1
		prevDirectionFacing_y = -1
	
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
	
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_pressed("jump") && velocity.y < -500 && let_go_off_jump == false:
			velocity.y += gravity * delta * jump_hold_mult
		else:
			velocity.y += gravity * delta * gliding_mult
			
		if Input.is_action_just_pressed("jump") && !on_wall() && delta_time > wall_jump_delay && !getHasBody():
			isGliding = true
			velocity.y = 0
		if Input.is_action_just_released("jump"):
			isGliding = false

		if isGliding:
			gliding_mult = gliding_mult_final
			max_speed = max_gliding_speed
		else:
			gliding_mult = 1
			if !getHasBody():
				max_speed = max_speed_final
			
	if Input.is_action_just_released("jump"): 
		let_go_off_jump = true
	
	if is_on_floor():
		isGliding = false
		if !getHasBody():
			max_speed = max_speed_final
		#Handle jump
		if Input.is_action_just_pressed("jump"):
			let_go_off_jump = false
			velocity.y = jump_velocity
	
	
	#print("held: ", direction_held, ", facing: ", direction_facing, ", on_wall(): ", on_wall(), ", isclingin:", isClinging)
	#Climbing
	if on_wall() and direction_held == direction_facing:
		isClinging = true
		isGliding = false
	
	if !on_wall():
		isClinging = false

	if isClinging:
		if direction_facing == 1:
			setRotate(-PI/2.0)
		else:
			setRotate(-PI/2.0)
		if Input.is_action_pressed("move_up"):
			velocity.y = -1 * wall_climbing_speed
		elif Input.is_action_pressed("move_down"):
			velocity.y = wall_climbing_speed
		else:
			velocity.y = 0
	else:
		setRotate(0)

		
		

	
	#Wall sliding/jumping
	if Input.is_action_just_pressed("jump") and isClinging:
		isClinging = false
		velocity.y = jump_velocity * 1.2
		velocity.x = wall_jump_pushback * -on_wall()
		wall_jump_timer = Time.get_ticks_msec()
	#print("x:", velocity.x, ", y:", velocity.y, ", max_speed:", max_speed)
	
	if Input.is_action_just_pressed("vent") and currVent.size() != 0:
		vent()
	
	if allow_debug:
		reset()
		if Input.is_action_just_pressed("debug"):
			in_debug_mode = !in_debug_mode
	if in_debug_mode:
		debug_mode()
	else:
		move_and_slide()
	
	
func setRotate(radians):
	get_child(1).set_rotation(radians)
	var tail = get_child(0)
	tail.set_rotation(radians)
	var newX
	var newY
	if radians == PI/2.0:
		newX = -baseTailPos.y
		newY = -baseTailPos.x
	elif radians == -PI/2.0:
		newX = baseTailPos.y
		newY = -baseTailPos.x
	else:
		newX = baseTailPos.x
		newY = baseTailPos.y
	tail.position.x = newX
	tail.position.y = newY
	
	#for node in get_children():
		#if node.get_class() != "AnimatedSprite2D":
			#node.set_rotation(0)
			
func debug_mode():
	velocity.x = 0
	velocity.y = 0
	velocity.x = Input.get_axis("move_left", "move_right") * 5000
	velocity.y = Input.get_axis("move_up", "move_down") * 5000
	move_and_slide()
	
	
func on_wall() -> float:
	if $RayCast2DRight.is_colliding() || $RayCast2DLeft.is_colliding():
		return 1
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
				
				
func set_is_dead(isdead):
	is_dead = isdead

var layerID = 2

func vent():
	var ventDir = currVent[0]
	var map = currVent[1]
	var ventLocation = map * 600
	if Input.is_action_just_pressed("vent"):
		inVent = !inVent
		match ventDir:
			1: #Left
				position.y = ventLocation.y + sign(ventLocation.y) * -300 - 200
				map.x -= 1
				while current_tilemap.get_cell_tile_data(layerID, map) != null and current_tilemap.get_cell_tile_data(layerID, map).get_custom_data("tileType") == 0:
					map.x -= 1
				position.x = map.x * 600 + 300
				emit_signal("venting")
			2: #Top
				position.x = ventLocation.x + 300
				map.y -= 1
				while current_tilemap.get_cell_tile_data(layerID, map) != null and current_tilemap.get_cell_tile_data(layerID, map).get_custom_data("tileType") == 0:
					map.y -= 1
				position.y = map.y * 600 + 300
				emit_signal("venting")
			3: #Right
				position.y = ventLocation.y + sign(ventLocation.y) * -300  - 200
				map.x += 1
				while current_tilemap.get_cell_tile_data(layerID, map) != null and current_tilemap.get_cell_tile_data(layerID, map).get_custom_data("tileType") == 0:
					map.x += 1
				position.x = map.x * 600 + 300
				emit_signal("venting")
			4: #Bottom
				position.x = ventLocation.x + 300
				map.y += 1
				while current_tilemap.get_cell_tile_data(layerID, map) != null and current_tilemap.get_cell_tile_data(layerID, map).get_custom_data("tileType") == 0:
					map.y += 1
				position.y = map.y * 600 + 100
				emit_signal("venting")

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
	if Input.is_action_just_pressed("reset"):
		position = spawn_pos

func grabBody():
	hasBody = true;
	max_speed = max_speed - 1500
	jump_velocity = jump_velocity + 2000
	wall_climbing_speed = wall_climbing_speed - 1500

func dropBody():
	hasBody = false
	max_speed = max_speed + 1500
	jump_velocity = jump_velocity - 2000
	wall_climbing_speed = wall_climbing_speed + 1500

func getHasBody():
	return hasBody

func getInVent():
	return inVent
