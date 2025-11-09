class_name SpriteWithMaterial
extends Node3D

var _materials: Array[ShaderMaterial] = []


func set_material(_material: ShaderMaterial):
	var sprites: Array = Utils.find_children_with_type(self, Sprite3D, true)
	if is_instance_of(self, Sprite3D):
		sprites.append(self)

	for sprite in sprites:
		var material := _material.duplicate(Utils.DEFAULT_DUPLICATE)
		material.set_shader_parameter("sprite_texture", sprite.texture)
		sprite.material_override = material
		_materials.append(material)


func set_material_parameter(parameter: StringName, value):
	for material in _materials:
		material.set_shader_parameter(parameter, value)


func _duplicate():
	return self.duplicate(Utils.DEFAULT_DUPLICATE)
