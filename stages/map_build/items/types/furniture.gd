@tool
extends MapBuilderItemCreator

@export var type: Furniture.Type


func _get_impl():
	var impl := Furniture.new(type, size)

	return impl
