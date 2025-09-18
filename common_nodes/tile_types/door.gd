extends WallLikeTile


func init(tile_size: float, impl_: Tile):
	super.init(tile_size, impl_)
	Impl.get_mixin(Blockable).blocking = false
