extends Node3D
class_name NodeFactory

@export var scenes: Array[PackedScene] = []

var _instances: Dictionary = {}

func _ready():
	hide()
	for scene in scenes:
		var val = scene.instantiate()
		self.add_child(val)
		var type = val.get_node("Impl").get("type")

		if not _instances.has(type):
			_instances.set(type, [val])
		else:
			_instances[type].append(val)
	self.position = Vector3(42, -999, 42)
