@tool
extends Node3D

class_name FactoryManager

var _factories: Dictionary[int, Array]

var _factories_scenes: Array[String]

func _init(factories_path: String):
	var root_dir := DirAccess.open(factories_path)

	if not root_dir:
		printerr("Can't open factories_path %", factories_path)
		return

	var dirs := [root_dir]

	while dirs.size():
		var dir: DirAccess = dirs.pop_front()

		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				dirs.append(dir)
				continue

			if file_name.get_extension() == "tscn":
				_factories_scenes.append(factories_path.path_join(file_name))

			file_name = dir.get_next()

func _ready():
	for scene in _factories_scenes:
		var factory: GridItemFactory = load(scene).instantiate()
		self.add_child(factory)
		
		if not _factories.has(factory.type):
			_factories.set(factory.type, [factory])
		else:
			_factories[factory.type].append(factory)



func get_factory(type: int):
	return _factories[type][0]
