extends NodeFactory
class_name CharacterNodeFactory


func create(type) -> CharacterStrategic:
	var result := _instances[type][0].duplicate(Utils.DEFAULT_DUPLICATE) as CharacterStrategic
	result.init(Character.new())

	return result
