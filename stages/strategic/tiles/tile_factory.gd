class_name StrategicTileFactory
extends NodeFactory


func create(map: Map, tile_impl: Tile) -> TileNode:
	var result := _instances[tile_impl.type][0].duplicate(Utils.DEFAULT_DUPLICATE) as TileNode
	result.set_data(tile_impl)
	result.map = map

	return result
