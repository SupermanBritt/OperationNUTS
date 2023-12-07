extends TileMap

@export var startInVent = false
	
var should_disapear = startInVent
var layer1_turning_visible = !startInVent
var alpha_delta = .06

func _use_tile_data_runtime_update(layer: int, _coords: Vector2i) -> bool:
	return layer in [1]

func _tile_data_runtime_update(_layer: int, _coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_collision_polygons_count(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Turning invisible
	if should_disapear and !layer1_turning_visible:
		var curr_mod = get_layer_modulate(1)
		curr_mod.a -= alpha_delta
		set_layer_modulate(1, curr_mod)
		if get_layer_modulate(1).a < 0:
			should_disapear = false
			curr_mod.a = 0
			set_layer_modulate(1, curr_mod)
			
	#Turning visible
	elif should_disapear and layer1_turning_visible:
		var curr_mod = get_layer_modulate(1)
		curr_mod.a += alpha_delta
		set_layer_modulate(1, curr_mod)
		if get_layer_modulate(1).a > 1:
			should_disapear = false
			curr_mod.a = 1
			set_layer_modulate(1, curr_mod)



func _on_squirrel_venting():
	should_disapear = true
	layer1_turning_visible = !layer1_turning_visible
