class_name TileModelAdapter
extends Node


func get_model(_tile: Tile, model):
	return model


func set_material(model, _material: ShaderMaterial):
	for mesh in Utils.find_children_with_type(model, MeshInstance3D, true):
		for i in mesh.get_surface_override_material_count():
			var albedo = mesh.get_active_material(i).albedo_texture
			_material.set_shader_parameter("_albedo", albedo)
			mesh.set_surface_override_material(i, _material)
