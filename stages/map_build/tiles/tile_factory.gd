class_name MapBuildTileFactory
extends NodeFactory


func create(tile_impl: Tile) -> Tile2D:
	var result := _instances[tile_impl.type][0].duplicate(Utils.DEFAULT_DUPLICATE) as Tile2D
	result.set_data(tile_impl)

	return result
