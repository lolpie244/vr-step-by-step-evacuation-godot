extends Node

class_name MapGrid

var type_grid: Array
var mesh_grid: Array

var tile_size: float

func _init(n: int, m: int, tile_size_: float = 0):
	tile_size = tile_size_

	mesh_grid = Utils.get_matrix(n, m)
	type_grid = Utils.get_matrix(n, m, Tile.Type.None)


static func from_str(str_map: Array) -> MapGrid:
	if str_map.size() < 0:
		return null

	var result = MapGrid.new(str_map.size(), str_map[0].size())

	for i in str_map.size():
		for j in str_map[i].size():
			match str_map[i][j]:
				"w":
					result.type_grid[i][j] = Tile.Type.Wall
				"f":
					result.type_grid[i][j] = Tile.Type.Floor
				"d":
					result.type_grid[i][j] = Tile.Type.Door
				_:
					push_warning("Unknown tile: on position [%, %]" % i, j)
					result.type_grid[i][j] = Tile.Type.None

	return result


func rows_count() -> int:
	return type_grid.size()


func columns_count() -> int:
	if type_grid.size() > 0:
		return type_grid[0].size()
	return 0


func get_type(x: int, y: int):
	if x < 0 || x >= rows_count() || y < 0 || y >= columns_count():
		return Tile.Type.None

	return type_grid[x][y]


func _transpose(arr: Array):
	var new_arr = []

	for i in range(len(arr[0])):
		var row = []
		for j in range(len(arr)):
			row.append(arr[len(arr) - j - 1][i])
		new_arr.append(row)

	return new_arr

func transpose():
	type_grid = _transpose(type_grid)
	mesh_grid = _transpose(mesh_grid)


func tile_position(x, y) -> Vector2:
	return (
		Vector2(tile_size * x, tile_size * y)
		- (Vector2(rows_count(), columns_count()) * tile_size / 2)
		+ Vector2(tile_size, tile_size) / 2
	)

func set_mesh(x: int, y: int, mesh: VisualInstance3D):
	mesh.position.x += tile_position(x, y).x
	mesh.position.z += tile_position(x, y).y

	mesh_grid[x][y] = mesh

func get_mesh(x: int, y: int) -> VisualInstance3D:
	return mesh_grid[x][y]
