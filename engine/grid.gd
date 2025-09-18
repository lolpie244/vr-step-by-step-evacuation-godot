class_name MapGrid
extends Node3D

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


func create_tile(type: Tile.Type, x: int, y: int) -> Tile:
	tiles[x][y] = Tile.new(type, self, x, y)
	return tiles[x][y]


func set_tile(x: int, y: int, tile: Tile):
	tiles[x][y] = tile


func get_tile(x: int, y: int) -> Tile:
	if not _in_range(x, y):
		return null
	return tiles[x][y]


func get_tile_mixin(x: int, y: int, type_ref):
	if not _in_range(x, y):
		return null

	var tile = tiles[x][y]
	if tile == null:
		return null

	return tile.get_mixin(type_ref)


func transpose():
	tiles = Utils.transpose(tiles)
