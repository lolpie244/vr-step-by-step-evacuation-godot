class_name NodeFactory
extends Node3D

var _instances: Dictionary = {}


func _ready():
	hide()
	for val in get_children():
		var type = val.get("type")
		val.process_mode = Node.PROCESS_MODE_DISABLED

		if not _instances.has(type):
			_instances.set(type, [val])
		else:
			_instances[type].append(val)
	self.position = Vector3(42, -999, 42)


func get_duplicate(node: Node3D):
	var result = node.duplicate(Utils.DEFAULT_DUPLICATE)
	result.process_mode = Node.PROCESS_MODE_ALWAYS

	return result


func set_material(material: ShaderMaterial):
	for variants in _instances.values():
		for instance in variants:
			for mesh in instance.get_children(true):
				if mesh.has_method(&"set_material"):
					mesh.set_material(material)
