extends MeshInstance3D
class_name Map

@onready var tile_manager: FactoryManager = $TileManager
@onready var character_manager: FactoryManager = $CharacterManager
@onready var grid = $Grid

@export var enable_cutoff: bool = true
@export var cutoff_shader: Shader
var cutoff_material: ShaderMaterial

var zoom: float:
	get():
		return grid.scale.x
	set(new_zoom):
		if new_zoom <= 0:
			return
		grid.scale = Vector3.ONE * new_zoom

var offset: Vector2:
	get():
		return Vector2(grid.position.x, grid.position.z)
	set(new_offset):
		grid.position.x = new_offset.x
		grid.position.z = new_offset.y

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

	var result = Utils.get_matrix(str_map.size(), str_map[0].size(), TileFactory.Type.None)

	for i in str_map.size():
		for j in str_map[i].size():
			match str_map[i][j]:
				"w":
					result[i][j] = TileFactory.Type.Wall
				"f":
					result[i][j] = TileFactory.Type.Floor
				"d":
					result[i][j] = TileFactory.Type.Door
				"o":
					result[i][j] = TileFactory.Type.Window
				_:
					push_warning("Unknown tile: on position [%, %]" % i, j)
					result.type_grid[i][j] = TileFactory.Type.None

	return result


func _ready() -> void:
	tile_manager.visible = false

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

	grid.resize(tile_types.size(), tile_types[0].size())

	var plane_size = self.get_aabb().size
	if (
		plane_size.x > plane_size.z and grid.rows_count() < grid.columns_count()
		or plane_size.x < plane_size.z and grid.rows_count() > grid.columns_count()
	):
		tile_types = Utils.transpose(tile_types)
		grid.transpose()

	grid.tile_size = min(
		self.get_aabb().size.x / grid.rows_count(), self.get_aabb().size.z / grid.columns_count()
	)

	# set flags
	for x in range(grid.rows_count()):
		for y in range(grid.columns_count()):
			var tile_factory: TileFactory = tile_manager.get_factory(tile_types[x][y])
			grid.set_tile(x, y, tile_factory.create(grid, x, y))

	for x in range(grid.rows_count()):
		for y in range(grid.columns_count()):
			var tile: Tile = grid.get_tile(x, y)
			tile.init()

			if enable_cutoff:
				if tile.model is MultiMeshInstance3D:
					tile.model.material_override = self.cutoff_material
				else:
					for i in tile.model.get_surface_override_material_count():
						tile.model.set_surface_override_material(i, self.cutoff_material)


func add_character(type: CharacterFactory.Type, x: int, y: int) -> Character:
	var factory: CharacterFactory = character_manager.get_factory(type)
	var character: Character = factory.create(grid, x, y)

	character.init()
	return character

func move_character(character: Character, x: int, y: int) -> bool:
	var tile = grid.get_tile(x, y) as Tile
	if tile == null || not tile.has_flag(Tile.Flags.WALKABLE):
		return false

	return tile.place_character(character)
