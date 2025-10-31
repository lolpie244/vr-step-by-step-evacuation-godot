class_name ItemsCatalog
extends Node


func set_material(material: ShaderMaterial):
	for sprite in Utils.find_children_with_type(self, SpriteWithMaterial, true):
		if sprite.has_method(&"set_material"):
			sprite.set_material(material)
