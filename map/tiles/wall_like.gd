extends Tile

class_name WallLikeTile

func _is_wall(map: MapGrid, x: int, y: int):
	return map.get_type(x, y) in WALL_LIKE_TYPES

func get_mesh(tile: TileOnGrid) -> VisualInstance3D:
	var left = _is_wall(tile.grid, tile.x - 1, tile.y)
	var right = _is_wall(tile.grid, tile.x + 1, tile.y)

	var result = _get_mesh_for_tile(model, tile)
	if left or right:
		result.rotate_y(deg_to_rad(90))
	return result
