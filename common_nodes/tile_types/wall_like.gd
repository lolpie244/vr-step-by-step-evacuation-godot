class_name WallLikeTile
extends TileNode


func set_data(_impl: Tile):
	super.set_data(_impl)
	impl.get_or_create_mixin(Blockable)


func _is_wall(x: int, y: int):
	var tile = GameCore.grid.get_tile(x, y)
	return tile != null and tile.is_wall_like


func _get_model():
	var left = _is_wall(impl.pos.x - 1, impl.pos.y)
	var right = _is_wall(impl.pos.x + 1, impl.pos.y)

	if left or right:
		model.rotate_y(deg_to_rad(90))

	return model
