class_name MapGrid
extends RefCounted

signal new_grid

var tiles: Array
var characters: Array[Character]
var items: Array[Item]

var size: Vector2:
	get():
		return Vector2(rows_count(), columns_count())


func _init(grid_size: Vector2i = Vector2i.ZERO):
	resize(grid_size.x, grid_size.y)


func is_empty():
	return tiles.is_empty()


func _in_range(x: int, y: int) -> bool:
	return x >= 0 && x < rows_count() && y >= 0 && y < columns_count()


# TODO: Copy content
func resize(n: int, m: int):
	tiles = Utils.get_matrix(n, m, null)
	new_grid.emit()


func reset():
	characters = []
	items = []
	resize(rows_count(), columns_count())


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


func add_item(item: Item):
	items.append(item)
	item.removed.connect(_on_item_removed)


func _on_item_removed(item: Item):
	items.erase(item)


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


func tile_position(tile_size, x, y) -> Vector3:
	return (
		Vector3(tile_size * x, 0, tile_size * y)
		- (Vector3(rows_count(), 0, columns_count()) * tile_size / 2)
		+ Vector3(tile_size, 0, tile_size) / 2
	)


func model_scale(tile_size, model) -> float:
	var model_size = Utils.get_aabb(model).size * model.scale
	return tile_size / max(model_size.x, model_size.z)


func strip():
	var left_corner := Vector2i(rows_count(), columns_count())
	var right_corner := Vector2i(0, 0)

	for x in range(rows_count()):
		for y in range(columns_count()):
			if !get_tile(x, y) or not get_tile(x, y).is_wall_like:
				continue

			left_corner = Vector2i(
				min(x, left_corner.x),
				min(y, left_corner.y),
			)

			right_corner = Vector2i(
				max(x, right_corner.x),
				max(y, right_corner.y),
			)
	right_corner += Vector2i.ONE
	if left_corner == Vector2i(0, 0) and right_corner == Vector2i(rows_count(), columns_count()):
		return

	var new_tiles = Utils.get_matrix(right_corner.x - left_corner.x, right_corner.y - left_corner.y)

	for x in range(left_corner.x, right_corner.x):
		for y in range(left_corner.y, right_corner.y):
			var tile: Tile = tiles[x][y]
			if !tile:
				continue
			tile._x = x - left_corner.x
			tile._y = y - left_corner.y
			new_tiles[tile._x][tile._y] = tile

	tiles = new_tiles
	new_grid.emit()
