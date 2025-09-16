extends NodeFactory
class_name TileNodeFactory


func create(type: Tile.Type, grid_: MapGrid, x_: int, y_: int) -> TileNode:
	var result := _instances[type][0].duplicate(Utils.DEFAULT_DUPLICATE) as TileNode
	result.get_node("Impl").instance.init(grid_, x_, y_)

	return result
