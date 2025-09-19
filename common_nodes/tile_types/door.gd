extends WallLikeTile


func set_data(tile_size: float, _impl: Tile):
	super.set_data(tile_size, _impl)
	impl.get_mixin(Blockable).blocking = false
