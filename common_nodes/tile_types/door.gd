extends WallLikeTile


func init(tile_size: float, _impl: Tile):
	super.init(tile_size, _impl)
	impl.get_mixin(Blockable).blocking = false
