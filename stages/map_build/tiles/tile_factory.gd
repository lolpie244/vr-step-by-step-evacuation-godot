class_name MapBuildTileFactory
extends NodeFactory


func create(tile_impl: Tile) -> Tile2D:
	var result := get_duplicate(_instances[tile_impl.type][0]) as Tile2D
	result.set_impl(tile_impl)

	return result
