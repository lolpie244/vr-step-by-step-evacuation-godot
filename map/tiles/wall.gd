extends WallLikeTile

@export var corner_model: MeshInstance3D


func get_mesh(tile: TileOnGrid) -> VisualInstance3D:
	var left = _is_wall(tile.grid, tile.x - 1, tile.y)
	var right = _is_wall(tile.grid, tile.x + 1, tile.y)
	var down = _is_wall(tile.grid, tile.x, tile.y - 1)
	var up = _is_wall(tile.grid, tile.x, tile.y + 1)

	var rotations := [[up, 0], [down, 180], [left, 270], [right, 90]].filter(func(x): return x[0])

	var result = MultiMeshInstance3D.new()
	result.scale = _get_scale(model, tile)

	var mm := MultiMesh.new()

	mm.mesh = model.mesh
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.instance_count = rotations.size()

	for i in rotations.size():
		var transform = Transform3D()
		transform = transform.rotated(Vector3(0, 1, 0), deg_to_rad(rotations[i][1]))

		var body = model.get_child(0).duplicate()
		body.transform = transform
		result.add_child(body)

		mm.set_instance_transform(i, transform)

	result.multimesh = mm

	return result
