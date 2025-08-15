extends MeshInstance3D

@onready var tile_manager = $TilesManager
@onready var items = $MapItems

@export var enable_cutoff: bool = true
@export var cutoff_shader: Shader
var cutoff_material: ShaderMaterial

var grid: MapGrid

var zoom: float:
	get():
		return items.scale.x
	set(new_zoom):
		if new_zoom <= 0:
			return
		items.scale = Vector3.ONE * new_zoom

var offset: Vector2:
	get():
		return Vector2(items.position.x, items.position.z)
	set(new_offset):
		items.position.x = new_offset.x
		items.position.z = new_offset.y

# temp
var test_map = [
	["w", "w", "w", "w", "w", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "f", "f", "d", "f", "w"],
	["w", "w", "w", "w", "w", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "w", "w", "w", "w", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "w", "w", "w", "w", "w"],
]


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
	grid = MapGrid.from_str(raw_map)

	var plane_size = self.get_aabb().size
	if (
		plane_size.x > plane_size.z and grid.rows_count() < grid.columns_count()
		or plane_size.x < plane_size.z and grid.rows_count() > grid.columns_count()
	):
		grid.transpose()

	grid.tile_size = min(
		self.get_aabb().size.x / grid.rows_count(), self.get_aabb().size.z / grid.columns_count()
	)

	for x in range(grid.rows_count()):
		for y in range(grid.columns_count()):
			var tile: Tile = tile_manager.get_tile(grid.get_type(x, y))

			var tile_mesh := tile.get_mesh(TileOnGrid.new(grid, x, y)) as VisualInstance3D

			if enable_cutoff:
				if tile_mesh is MultiMeshInstance3D:
					tile_mesh.material_override = self.cutoff_material
				else:
					for i in tile_mesh.get_surface_override_material_count():
						tile_mesh.set_surface_override_material(i, self.cutoff_material)

			grid.set_mesh(x, y, tile_mesh)
			items.add_child(tile_mesh)

# func place_character(character: Character, x: int, y: int):
# 	pass
