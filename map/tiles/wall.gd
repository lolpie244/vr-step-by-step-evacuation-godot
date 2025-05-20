extends Tile

const WALL_LIKE_TYPES = [Type.Wall, Type.Door, Type.Window]

@export var corner_model: MeshInstance3D


func get_mesh(tile: TileOnMap) -> VisualInstance3D:
	var wall = func(x, y):
		if x < 0 || x >= tile.map[0].size() || y < 0 || y >= tile.map.size():
			return false
		return tile.map[x][y] in WALL_LIKE_TYPES

	var left = wall.call(tile.x - 1, tile.y)
	var right = wall.call(tile.x + 1, tile.y)
	var down = wall.call(tile.x, tile.y - 1)
	var up = wall.call(tile.x, tile.y + 1)

	var horizontal = left or right
	var vertical = up or down

	if not (horizontal and vertical):
		var result = _get_mesh_for_tile(model, tile)
		if left or right:
			result.rotate_y(deg_to_rad(90))
		return result

	var rotations := []

	if left and up:
		rotations.append(0)
	if up and right:
		rotations.append(90)
	if right and down:
		rotations.append(180)
	if down and left:
		rotations.append(270)

	var mm := MultiMesh.new()

	mm.mesh = corner_model.mesh
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.instance_count = rotations.size()

	for i in rotations.size():
		var transform = Transform3D()
		transform = transform.rotated(Vector3(0, 1, 0), deg_to_rad(rotations[i]))

		mm.set_instance_transform(i, transform)

	var result = MultiMeshInstance3D.new()
	result.scale = _get_scale(corner_model, tile)
	result.multimesh = mm

	return result
