class_name StrategicTileFactory
extends NodeFactory


func create(tile_impl: Tile) -> TileNode:
	var result := get_duplicate(_instances[tile_impl.type][0]) as TileNode
	result.set_data(tile_impl)

	return result
