@tool
extends MapBuilderItemCreator

@export var extinguisher_type: Extinguisher.Type


func _get_impl():
	var impl := Extinguisher.new(extinguisher_type)

	return impl
