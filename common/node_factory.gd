class_name NodeFactory
extends Node3D

var _instances: Dictionary = {}


func _ready():
	hide()
	for val in get_children():
		var type = val.get("type")

		if not _instances.has(type):
			_instances.set(type, [val])
		else:
			_instances[type].append(val)
	self.position = Vector3(42, -999, 42)
