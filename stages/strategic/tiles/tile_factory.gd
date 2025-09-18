extends NodeFactory
class_name TileNodeFactory


func create(type: Tile.Type, map: Map, tile_impl: Tile) -> TileNode:
	var result := _instances[type][0].duplicate(Utils.DEFAULT_DUPLICATE) as TileNode
	result.init(map, tile_impl)

	return result
