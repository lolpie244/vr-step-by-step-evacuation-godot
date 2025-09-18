class_name NodeFactory
extends Node3D

@export var scenes: Array[PackedScene] = []

var _instances: Dictionary = {}


func _ready():
	hide()
	for scene in scenes:
		var val = scene.instantiate()
		var type = val.get("type")

		if not _instances.has(type):
			_instances.set(type, [val])
		else:
			_instances[type].append(val)
	self.position = Vector3(42, -999, 42)
