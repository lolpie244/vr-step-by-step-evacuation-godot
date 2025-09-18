extends NodeFactory
class_name StrategicTileFactory

func create(map: Map, tile_impl: Tile) -> TileNode:
	var result := _instances[tile_impl.type][0].duplicate(Utils.DEFAULT_DUPLICATE) as TileNode
	result.init(map._tile_size, tile_impl)
	result.set_map(map)

	return result
