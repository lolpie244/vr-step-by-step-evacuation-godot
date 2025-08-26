extends WallLikeTile


func _generate_model():
	var left = _is_wall(_x - 1, _y)
	var right = _is_wall(_x + 1, _y)
	var down = _is_wall(_x, _y - 1)
	var up = _is_wall(_x, _y + 1)

	var rotations := [[up, 0], [down, 180], [left, 270], [right, 90]].filter(func(v): return v[0])

	var model = _shared_data.model

	var result = MultiMeshInstance3D.new()
	result.scale = Vector3.ONE * _get_model_scale(model)

	var mm := MultiMesh.new()

	mm.mesh = model.mesh
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.instance_count = rotations.size()

	for i in rotations.size():
		var mm_transform = Transform3D()
		mm_transform = mm_transform.rotated(Vector3(0, 1, 0), deg_to_rad(rotations[i][1]))

		var body = model.get_child(0).duplicate()
		body.transform = mm_transform
		result.add_child(body)

		mm.set_instance_transform(i, mm_transform)

	result.multimesh = mm

	return result
