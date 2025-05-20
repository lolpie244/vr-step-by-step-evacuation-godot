extends Tile

class_name WallLikeTile

func _is_wall(map, x, y):
	if x < 0 || x >= map[0].size() || y < 0 || y >= map.size():
		return false
	return map[x][y] in WALL_LIKE_TYPES


func get_mesh(tile: TileOnMap) -> VisualInstance3D:
	var left = _is_wall(tile.map, tile.x - 1, tile.y)
	var right = _is_wall(tile.map, tile.x + 1, tile.y)

	var result = _get_mesh_for_tile(model, tile)
	if left or right:
		result.rotate_y(deg_to_rad(90))
	return result


