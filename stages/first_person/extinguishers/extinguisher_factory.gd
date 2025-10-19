class_name FirstPersonExtinguisherFactory
extends NodeFactory


func create(impl: Extinguisher, dropper_position: Vector3) -> ExtinguisherDropper:
	var result := _instances[impl.type].duplicate(Utils.DEFAULT_DUPLICATE) as ExtinguisherDropper
	result.extinguisher.set_data(impl)
	result.position = dropper_position

	return result
