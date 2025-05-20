extends Tile

const WALL_LIKE_TYPES = [Type.Wall, Type.Door, Type.Window]

@export var corner_model: MeshInstance3D


func get_mesh(tile: TileOnMap) -> VisualInstance3D:
	var is_not_wall = func(x, y):
		if x < 0 || x >= tile.map[0].size() || y < 0 || y >= tile.map.size():
			return true
		return not tile.map[x][y] in WALL_LIKE_TYPES

	var left = is_not_wall.call(tile.x - 1, tile.y)
	var right = is_not_wall.call(tile.x + 1, tile.y)
	var down = is_not_wall.call(tile.x, tile.y - 1)
	var up = is_not_wall.call(tile.x, tile.y + 1)

	if (left or right) and (up or down):
		var mesh := _get_mesh_for_tile(corner_model, tile)
		var rotate_to: int = 0

		if right and down:
			rotate_to = 0
		elif down and left:
			rotate_to = 90
		elif left and up:
			rotate_to = 180
		elif up and right:
			rotate_to = 270

		mesh.rotate_y(deg_to_rad(rotate_to))
		return mesh
	else:
		var mesh := _get_mesh_for_tile(model, tile)
		if up or down:
			mesh.rotate_y(deg_to_rad(90))
		return mesh
