class_name WallMesh
extends WallLikeMesh

@export var _model: MultiMeshInstance3D


func _ready():
	if _model:
		return

	var mesh_instance

	if is_instance_of(self, MeshInstance3D):
		mesh_instance = self
	else:
		mesh_instance = Utils.find_child_with_type(self, MeshInstance3D, false)

	_model = MultiMeshInstance3D.new()
	_model.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	var mm := MultiMesh.new()
	mm.mesh = mesh_instance.mesh
	mm.transform_format = MultiMesh.TRANSFORM_3D

	_model.transform = self.transform
	_model.multimesh = mm


func set_material(_material: ShaderMaterial):
	var mm = _model.multimesh
	for i in mm.mesh.get_surface_count():
		var active_material = mm.mesh.surface_get_material(i)

		var material := _material.duplicate(Utils.DEFAULT_DUPLICATE)
		self.copy_standard_to_shader(active_material, material)
		mm.mesh.surface_set_material(i, material)

		_materials.append(material)


func get_transformed(tile: Tile):
	var model = _duplicate()

	var left = _is_wall(tile.grid, tile.pos.x - 1, tile.pos.y)
	var right = _is_wall(tile.grid, tile.pos.x + 1, tile.pos.y)
	var down = _is_wall(tile.grid, tile.pos.x, tile.pos.y - 1)
	var up = _is_wall(tile.grid, tile.pos.x, tile.pos.y + 1)

	var rotations := [[up, 0], [down, 180], [left, 270], [right, 90]].filter(func(v): return v[0])

	var mm: MultiMesh = model.multimesh
	mm.instance_count = rotations.size()

	for i in rotations.size():
		var mm_transform = Transform3D()
		mm_transform = mm_transform.rotated(Vector3(0, 1, 0), deg_to_rad(rotations[i][1]))

		if model.get_child_count():
			var body = model.get_child(0).duplicate()
			body.transform = mm_transform
			model.add_child(body)

		mm.set_instance_transform(i, mm_transform)

	return model


func _duplicate():
	var result = _model.duplicate(Utils.DEFAULT_DUPLICATE)
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = _model.multimesh.mesh

	result.multimesh = mm
	return result
