extends WallLikeTile


func set_data(_impl: Tile):
	super.set_data(_impl)
	impl.get_mixin(Blockable).blocking = false
