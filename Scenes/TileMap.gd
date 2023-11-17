extends TileMap

var should_disapear = false
var layer1_visible = true
var alpha_delta = .06

func ready():
	var tiles = get_used_cells(1)
	for tile in tiles:
		get_cell_tile_data(1, tile).remove_collision_polygon(1, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if should_disapear and layer1_visible:
		var curr_mod = get_layer_modulate(1)
		curr_mod.a -= alpha_delta
		set_layer_modulate(1, curr_mod)
		if get_layer_modulate(1).a < 0:
			should_disapear = false
			layer1_visible = false
			curr_mod.a = 0
			set_layer_modulate(1, curr_mod)

	elif should_disapear and !layer1_visible:
		var curr_mod = get_layer_modulate(1)
		curr_mod.a += alpha_delta
		set_layer_modulate(1, curr_mod)
		if get_layer_modulate(1).a > 1:
			should_disapear = false
			layer1_visible = true
			curr_mod.a = 1
			set_layer_modulate(1, curr_mod)



func _on_squirrel_venting():
	should_disapear = true
