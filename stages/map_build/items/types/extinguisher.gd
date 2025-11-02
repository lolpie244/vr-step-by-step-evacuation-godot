@tool
extends MapBuilderItemCreator

@export var type: Extinguisher.Type


func _get_impl():
	var impl := Extinguisher.new(type)

	return impl
