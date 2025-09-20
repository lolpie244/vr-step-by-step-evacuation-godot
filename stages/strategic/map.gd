class_name Map
extends MeshInstance3D

@export var cutoff_shader: Shader
var cutoff_material: ShaderMaterial

var zoom: float:
	get():
		return map_items.scale.x
	set(new_zoom):
		if new_zoom <= 0:
			return
		map_items.scale = Vector3.ONE * new_zoom

var offset: Vector2:
	get():
		return Vector2(map_items.position.x, map_items.position.z)
	set(new_offset):
		map_items.position.x = new_offset.x
		map_items.position.z = new_offset.y

var _tile_size: float
var _tile_nodes: Array
var _characters: Array

@onready var impl: MapGrid = GameCore.grid
@onready var tile_factory: StrategicTileFactory = $StrategicTileFactory
@onready var character_factory: CharacterNodeFactory = $CharacterNodeFactory
@onready var map_items = $MapItems

# temp
var test_map = [
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
	var plane_mesh := self.mesh as PlaneMesh
	plane_mesh.size = Vector2(
		self.get_aabb().size.x * self.scale.x, self.get_aabb().size.z * self.scale.z
	)
	self.scale = Vector3.ONE

	var plane_pos = global_transform.origin
	cutoff_material = ShaderMaterial.new()
	cutoff_material.shader = cutoff_shader
	cutoff_material.set_shader_parameter("plane_size", plane_mesh.size * 0.5)
	cutoff_material.set_shader_parameter("plane_pos", Vector2(plane_pos.x, plane_pos.z))
	cutoff_material.set_shader_parameter("border_color", Color.RED)

	set_map(test_map)


func set_map(raw_map):
	var tile_types := types_from_str(raw_map)

	impl.resize(tile_types.size(), tile_types[0].size())
	_tile_nodes = Utils.get_matrix(tile_types.size(), tile_types[0].size())

	var plane_size = self.get_aabb().size
	if (
		plane_size.x > plane_size.z and impl.rows_count() < impl.columns_count()
		or plane_size.x < plane_size.z and impl.rows_count() > impl.columns_count()
	):
		tile_types = Utils.transpose(tile_types)
		impl.transpose()

	_tile_size = min(
		self.get_aabb().size.x / impl.rows_count(), self.get_aabb().size.z / impl.columns_count()
	)

	# set flags
	for x in range(impl.rows_count()):
		for y in range(impl.columns_count()):
			var tile_impl = impl.create_tile(tile_types[x][y], x, y)
			_tile_nodes[x][y] = tile_factory.create(self, tile_impl)
			map_items.add_child(_tile_nodes[x][y])

	for x in range(impl.rows_count()):
		for y in range(impl.columns_count()):
			var tile: TileNode = _tile_nodes[x][y]
			tile.init()
			tile.set_material(self.cutoff_material)


func add_character(type: Character.Type, x: int, y: int):
	var character_impl: Character = impl.create_character(type)
	var character: CharacterStrategic = character_factory.create(character_impl)
	_characters.append(character)
	character.impl.place(impl.get_tile(x, y))
	character.set_material(self.cutoff_material)

	return character


func get_tile_node(pos: Vector2i):
	if !impl._in_range(pos.x, pos.y):
		return null
	return _tile_nodes[pos.x][pos.y]


func get_character_node(character: Character):
	for node in _characters:
		if node.impl == character:
			return node
	return null
