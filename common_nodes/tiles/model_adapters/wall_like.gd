class_name WallLikeModelAdapter
extends TileModelAdapter


func _is_wall(grid: MapGrid, x: int, y: int):
	var tile = grid.get_tile(x, y)
	return tile != null and tile.is_wall_like


func get_model(tile: Tile, model):
	var left = _is_wall(tile.grid, tile.pos.x - 1, tile.pos.y)
	var right = _is_wall(tile.grid, tile.pos.x + 1, tile.pos.y)

	if left or right:
		model.rotate_y(deg_to_rad(90))

	return model
