@tool
extends MapBuilderItemCreator

@export var extinguisher_type: Extinguisher.Type
@export var fire_types: Array[FlammableMaterial.FireType] = []


func _get_impl():
	var impl := Extinguisher.new(extinguisher_type)
	impl.fire_types = fire_types

	return impl
