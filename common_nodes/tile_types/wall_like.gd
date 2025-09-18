extends TileNode
class_name WallLikeTile


func init(tile_size: float, impl_: Tile):
	super.init(tile_size, impl_)
	Impl.get_or_create_mixin(Blockable)


func _is_wall(x_: int, y_: int):
	var tile = GameCore.grid.get_tile_mixin(x_, y_, Blockable)
	return tile != null and tile.is_wall_like


func _get_model():
	var left = _is_wall(Impl.pos.x - 1, Impl.pos.y)
	var right = _is_wall(Impl.pos.x + 1, Impl.pos.y)

	if left or right:
		model.rotate_y(deg_to_rad(90))

	return model
