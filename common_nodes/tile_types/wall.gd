extends WallLikeTile

@onready var original_mesh = $Model.mesh
@onready var original_material = $Model.get_active_material(0)


func _get_model():
	var left = _is_wall(impl.pos.x - 1, impl.pos.y)
	var right = _is_wall(impl.pos.x + 1, impl.pos.y)
	var down = _is_wall(impl.pos.x, impl.pos.y - 1)
	var up = _is_wall(impl.pos.x, impl.pos.y + 1)

	var rotations := [[up, 0], [down, 180], [left, 270], [right, 90]].filter(func(v): return v[0])

	var result = MultiMeshInstance3D.new()
	result.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var mm := MultiMesh.new()

	mm.mesh = original_mesh
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.instance_count = rotations.size()

	for i in rotations.size():
		var mm_transform = Transform3D()
		mm_transform = mm_transform.rotated(Vector3(0, 1, 0), deg_to_rad(rotations[i][1]))

		if model.get_child_count():
			var body = model.get_child(0).duplicate()
			body.transform = mm_transform
			result.add_child(body)

		mm.set_instance_transform(i, mm_transform)

	result.multimesh = mm
	result.transform = $Model.transform
	return result


func set_material(_material: ShaderMaterial):
	var material = _material.duplicate()
	var albedo = original_material.albedo_texture
	material.set_shader_parameter("_albedo", albedo)
	model.material_override = material
