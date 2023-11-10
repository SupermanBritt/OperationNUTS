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
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
 

func _physics_process(delta):
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_held = Input.get_axis("move_left", "move_right")
	var delta_time = Time.get_ticks_msec() - wall_jump_timer
	
	if direction_held:
		isClinging = false
		
	if delta_time > wall_jump_delay:
		if abs(velocity.x + direction_held * acceleration) <= max_speed:
			velocity.x += direction_held * acceleration
		else:
			velocity.x = max_speed * direction_held

	# -1 moving left, 0 standing still, 1 moving right
	var direction_moving = 0
	
	#Friction
	if velocity.x != 0:
		direction_moving = velocity.x / abs(velocity.x)
		if abs(velocity.x) - friction < 0:
			velocity.x = 0
		else:
			velocity.x -= friction * direction_moving
	
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
	
	vent_check()
	
	move_and_slide()

func on_wall() -> float:
	if $RayCast2DRight.is_colliding():
		return 1
	elif $RayCast2DLeft.is_colliding():
		return -1
	else:
		return 0

var current_tilemap: TileMap

enum TileType {
	LEFTVENT = 0,
	BOTTOMVENT = 1,
	RIGHTVENT = 2,
	TOPVENT = 3
}

func _update_terrain(terrain_mask : Variant):
	print(terrain_mask)

func _process_tilemap_collision(body: Node2D, body_rid: RID):
		current_tilemap = body
		
		var collided_tile_coords = current_tilemap.get_coords_for_body_rid(body_rid)
		for index in current_tilemap.get_layers_count():
			var tile_data = current_tilemap.get_cell_tile_data(index, collided_tile_coords)
			if !tile_data is TileData:
				continue
			var terrain_mask = tile_data.get_custom_data_by_layer_id(0)
			_update_terrain(terrain_mask)
			break

func _on_body_shape_entered(body_rid: RID, body : Node2D, _body_shape_index : int, _local_shape_index : int):
	print("GERe")
	if body is TileMap:
		_process_tilemap_collision(body, body_rid)
		
func vent_check():
	if check_vent_dir($RayCast2DRight, 2):
		print("4")

func check_vent_dir(raycast : RayCast2D, dir : int) -> bool:
	var colliding = raycast.is_colliding()
	var collision_point = raycast.get_collision_point()
	var map = current_tilemap.world_to_map(Vector2(0,0))
	print(current_tilemap.get_cell(map.x, map.y))
	return false
