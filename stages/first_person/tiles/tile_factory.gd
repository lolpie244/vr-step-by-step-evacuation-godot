class_name FirstPersonTileFactory
extends NodeFactory


func create(tile_impl: Tile) -> TileNode:
	var result := _instances[tile_impl.type][0].duplicate(Utils.DEFAULT_DUPLICATE) as TileNode
	result.set_data(tile_impl)

	return result
