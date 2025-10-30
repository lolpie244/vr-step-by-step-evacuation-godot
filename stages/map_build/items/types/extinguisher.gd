@tool
extends MapBuilderItemCreator

@export var type: Extinguisher.Type


func _get_impl():
	var impl := Extinguisher.new(size)
	impl.type = type

	return impl
