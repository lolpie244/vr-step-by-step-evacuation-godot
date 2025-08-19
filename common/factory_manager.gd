@tool
extends Node3D

class_name FactoryManager

var _factories: Dictionary[int, Array]

func _ready():
	for factory in self.get_children():
		if not _factories.has(factory.type):
			_factories.set(factory.type, [factory])
		else:
			_factories[factory.type].append(factory)


func get_factory(type: int):
	return _factories[type][0]
