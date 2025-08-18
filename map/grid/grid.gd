extends Node3D

class_name MapGrid

var tiles: Array
var tile_size: float


func _in_range(x: int, y: int) -> bool:
	return x >= 0 && x < rows_count() && y >= 0 && y < columns_count()


# TODO: Copy content
func resize(n: int, m: int):
	tiles = Utils.get_matrix(n, m, null)


func rows_count() -> int:
	return tiles.size()


func columns_count() -> int:
	if tiles.size() > 0:
		return tiles[0].size()
	return 0


func set_tile(x: int, y: int, tile: Tile):
	tiles[x][y] = tile


func get_tile(x: int, y: int) -> Tile:
	if not _in_range(x, y):
		return null

	return tiles[x][y]


func transpose():
	tiles = Utils.transpose(tiles)


func tile_position(x, y) -> Vector3:
	return (
		Vector3(tile_size * x, 0, tile_size * y)
		- (Vector3(rows_count(), 0, columns_count()) * tile_size / 2)
		+ Vector3(tile_size, 0, tile_size) / 2
	)


func set_character(character: Character, x, y) -> bool:
	if not _in_range(x, y) || tiles[x][y] == null || not tiles[x][y].has_flag(Tile.Flags.WALKABLE):
		return false

	return tiles[x][y].add_character(character)
