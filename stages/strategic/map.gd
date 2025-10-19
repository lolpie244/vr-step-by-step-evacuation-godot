extends Map

var _tile_nodes: Array
var _characters: Array

# temp
var _test_map = [
	["w", "w", "w", "w", "w", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "f", "f", "d", "f", "w"],
	["w", "w", "w", "w", "d", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "w", "w", "w", "f", "w"],
	["w", "f", "f", "d", "f", "w"],
	["o", "f", "f", "w", "f", "w"],
	["o", "f", "f", "w", "f", "w"],
	["o", "f", "f", "w", "f", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "w", "w", "w", "w", "w"],
]

@onready var tile_factory = $TileFactory
@onready var character_factory: CharacterNodeFactory = $CharacterFactory


# TODO: only for testing
static func types_from_str(str_map: Array) -> Array:
	if str_map.size() < 0:
		return []

	var result = Utils.get_matrix(str_map.size(), str_map[0].size(), Tile.Type.NONE)

	for i in str_map.size():
		for j in str_map[i].size():
			match str_map[i][j]:
				"w":
					result[i][j] = Tile.Type.WALL
				"f":
					result[i][j] = Tile.Type.FLOOR
				"d":
					result[i][j] = Tile.Type.DOOR
				"o":
					result[i][j] = Tile.Type.WINDOW
				_:
					push_warning("Unknown tile: on position [%, %]" % i, j)
					result.type_grid[i][j] = Tile.Type.NONE

	return result


func _ready() -> void:
	super._ready()
	impl.new_grid.connect(reset_map)

	if impl.is_empty():
		impl.set_tiles(types_from_str(_test_map))
	else:
		reset_map()


func reset_map():
	_tile_nodes = Utils.get_matrix(impl.rows_count(), impl.columns_count())

	_tile_size = min(
		self.get_aabb().size.x / impl.rows_count(), self.get_aabb().size.z / impl.columns_count()
	)

	for x in range(impl.rows_count()):
		for y in range(impl.columns_count()):
			if !impl.get_tile(x, y):
				continue

			var tile: TileNode = tile_factory.create(self, impl.get_tile(x, y))
			_tile_nodes[x][y] = tile

	for x in range(impl.rows_count()):
		for y in range(impl.columns_count()):
			if _tile_nodes[x][y]:
				place_item(_tile_nodes[x][y], x, y)


func add_character(type: Character.Type, x: int, y: int):
	var character_impl: Character = impl.create_character(type)
	var character: CharacterStrategic = character_factory.create(character_impl)
	_characters.append(character)
	character.impl.place(impl.get_tile(x, y))
	character.set_material(self.cutoff_material)

	return character


func get_character_node(character: Character):
	for node in _characters:
		if node.impl == character:
			return node
	return null
