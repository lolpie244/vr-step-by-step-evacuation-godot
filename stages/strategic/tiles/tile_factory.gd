class_name StrategicTileFactory
extends NodeFactory


func create(map: Map, tile_impl: Tile) -> StrategicTileNode:
	var result := get_duplicate(_instances[tile_impl.type][0]) as StrategicTileNode
	result.set_data(tile_impl)
	result.map = map

	return result
