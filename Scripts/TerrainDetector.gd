extends Area2D

signal terrain_entered(terrain_type, tile_coords, current_tilemap)
signal terrain_exited

var current_tilemap: TileMap
var previous_terrain : int  = -1
var current_terrain : int  = -1

enum TileType {
	NORMAL = 0,
	LEFTVENT = 1,
	TOPVENT = 2,
	RIGHTVENT = 3,
	BOTTOMVENT = 4
}

func _process_tilemap_collision(body: Node2D, body_rid: RID):
		current_tilemap = body
		for index in current_tilemap.get_layers_count():
			var collided_tile_coords = current_tilemap.get_coords_for_body_rid(body_rid)
			var tile_data = current_tilemap.get_cell_tile_data(2, collided_tile_coords)
			if !tile_data is TileData:
				continue
			var terrain_mask = tile_data.get_custom_data_by_layer_id(0)
			emit_signal("terrain_entered", terrain_mask, collided_tile_coords, current_tilemap)
			break
			

func _on_body_shape_entered(body_rid: RID, body : Node2D, _body_shape_index : int, _local_shape_index : int):
	if body is TileMap:
		_process_tilemap_collision(body, body_rid)
		
		
#This does nothing but it crashes if I remove it
func _on_terrain_entered(_d, _f, _l):
	return

func _on_body_shape_exited(_body_rid: RID, _body : Node2D, _body_shape_index : int, _local_shape_index : int):
	return
