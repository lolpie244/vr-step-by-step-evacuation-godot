class_name ItemsCatalog
extends Node

var _instances: Dictionary = {}


func _ready():
	for val in get_children():
		var type = val.get("type")

		if not _instances.has(type):
			_instances.set(type, [val])
		else:
			_instances[type].append(val)


func set_material(material: ShaderMaterial):
	for sprite in Utils.find_children_with_type(self, SpriteWithMaterial, true):
		if sprite.has_method(&"set_material"):
			sprite.set_material(material)


func create(impl: Item):
	var variations: Array = _instances[impl.get_type()]

	for variation in variations:
		if variation.size == impl.size:
			variation.create_node(impl)
			impl.restore_position()
			return
