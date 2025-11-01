class_name StrategicItemFactory
extends NodeFactory


func create(impl: Item) -> ItemNode:
	var variations: Array = _instances[impl.get_type()]

	for variation in variations:
		if variation.size == impl.size:
			var result := get_duplicate(variation) as ItemNode
			result.set_impl(impl)

			return result
	return null
