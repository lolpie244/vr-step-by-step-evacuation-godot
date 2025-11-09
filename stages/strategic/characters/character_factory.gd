class_name CharacterNodeFactory
extends NodeFactory


func create(impl: Character) -> CharacterStrategic:
	var result := get_duplicate(_instances[impl.type][0]) as CharacterStrategic
	result.init(impl)

	return result
