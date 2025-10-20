class_name FirstPersonExtinguisherFactory
extends NodeFactory


func create(impl: Extinguisher, dropper_position: Vector3) -> ExtinguisherDropper:
	var result := get_duplicate(_instances[impl.type][0]) as ExtinguisherDropper

	result.extinguisher = Utils.find_child_with_type(result, ExtinguisherNode, false)
	result.extinguisher.set_data(impl)
	result.position = dropper_position

	return result
