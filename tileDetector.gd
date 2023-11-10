#extends Area2D
#
#var current_tilemap: TileMap
#var current_terrain_area: Terrain
#enum TileType {
#	LEFTVENT = 0,
#	BOTTOMVENT = 1,
#	RIGHTVENT = 2,
#	TOPVENT = 3
#}
#
#func _process_tilemap_collision(body: Node2D, body_rid: RID):
#		current_tilemap = body
#
#		var collided_tile_coords = current_tilemap.get_coords_for_body_rid(body_rid)
#
#func _on_body_shape_entered(body_rid: RID, body : Node2D, _body_shape_index : int, _local_shape_index : int):
#		if body is TileMap:
#			_process_tilemap_collision(body, body_rid)
