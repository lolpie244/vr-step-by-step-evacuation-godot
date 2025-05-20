extends MeshInstance3D

@onready var tile_manager = $TilesManager

var test_map = [
	["w", "w", "w", "w", "w", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "f", "f", "d", "f", "w"],
	["w", "w", "w", "w", "w", "w"],
	["w", "f", "f", "w", "f", "w"],
	["w", "w", "w", "w", "w", "w"],
]


func _convert_map(map: Array) -> Array:
	var result = map.duplicate()

	for i in map.size():
		for j in map[i].size():
			match map[i][j]:
				"w":
					result[i][j] = Tile.Type.Wall
				"f":
					result[i][j] = Tile.Type.Floor
				"d":
					result[i][j] = Tile.Type.Door
				_:
					push_warning("Unknown tile: on position [%, %]" % i, j)
					result[i][j] = Tile.Type.None

	return result


func _ready() -> void:
	var plane_mesh := self.mesh as PlaneMesh
	plane_mesh.size = Vector2(
		self.get_aabb().size.x * self.scale.x, self.get_aabb().size.z * self.scale.z
	)
	self.scale = Vector3(1, 1, 1)

	set_map(test_map)


func set_map(raw_map):
	var map = _convert_map(raw_map)

	var tile_size = min(self.get_aabb().size.z / map.size(), self.get_aabb().size.x / map[0].size())
	var start_point = (
		-Vector3(map[0].size() * tile_size / 2, 0, map.size() * tile_size / 2)
		+ Vector3(tile_size / 2, 0, tile_size / 2)
	)

	var tile_pos = Vector3(tile_size, self.position.y, tile_size)

	for y in range(map.size()):
		for x in range(map[y].size()):
			var tile: Tile = tile_manager.get_tile(map[x][y])

			var cell_mesh := tile.get_mesh(TileOnMap.new(map, x, y, tile_size))
			cell_mesh.position += start_point + Vector3(tile_pos.x * x, 0, tile_pos.z * y)

			self.add_child(cell_mesh)
