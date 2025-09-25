class_name MapGrid
extends Node3D

signal new_grid

var tiles: Array
var characters: Array[Character]

func set_tiles(tile_types: Array):
	if tile_types.is_empty():
		return
		
	self.resize(tile_types.size(), tile_types[0].size())
	for x in range(rows_count()):
		for y in range(columns_count()):
			if tile_types[x][y]:
				create_tile(tile_types[x][y], x, y)

	new_grid.emit()

func is_empty():
	return tiles.is_empty()

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


func create_character(type: Character.Type) -> Character:
	var character := Character.new(type)
	characters.append(character)
	return character


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


func process_turn(_turn_number: int):
	for x in rows_count():
		for y in columns_count():
			if tiles[x][y]:
				tiles[x][y].process_turn(_turn_number)

	for character in characters:
		character.process_turn(_turn_number)
