class_name MeshWithMaterial
extends Node3D

var _materials: Array[ShaderMaterial] = []


func set_material(_material: ShaderMaterial):
	var meshes: Array = Utils.find_children_with_type(self, MeshInstance3D, true)
	if is_instance_of(self, MeshInstance3D):
		meshes.append(self)

	for mesh in meshes:
		for i in mesh.get_surface_override_material_count():
			var active_material: StandardMaterial3D = mesh.get_active_material(i)
			var material := _material.duplicate(Utils.DEFAULT_DUPLICATE)

			self.copy_standard_to_shader(active_material, material)
			mesh.set_surface_override_material(i, material)

			_materials.append(material)


func set_material_parameter(parameter: StringName, value):
	for material in _materials:
		material.set_shader_parameter(parameter, value)


func _duplicate():
	return self.duplicate(Utils.DEFAULT_DUPLICATE)


static func copy_standard_to_shader(source: StandardMaterial3D, target: ShaderMaterial) -> void:
	# Colors and scalars
	target.set_shader_parameter(&"albedo", source.albedo_color)
	target.set_shader_parameter(&"texture_albedo", source.albedo_texture)

	target.set_shader_parameter(&"roughness", source.roughness)
	target.set_shader_parameter(&"texture_metallic", source.metallic_texture)
	target.set_shader_parameter(&"metallic_texture_channel", source.metallic_texture_channel)

	target.set_shader_parameter(&"specular", source.specular_mode)
	target.set_shader_parameter(&"metallic", source.metallic)
