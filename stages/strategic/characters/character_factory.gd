class_name CharacterNodeFactory
extends NodeFactory


func create(impl: Character) -> CharacterStrategic:
	var result := _instances[impl.type][0].duplicate(Utils.DEFAULT_DUPLICATE) as CharacterStrategic
	result.init(impl)

	return result
