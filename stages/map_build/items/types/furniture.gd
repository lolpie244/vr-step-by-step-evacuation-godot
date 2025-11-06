@tool
extends MapBuilderItemCreator

@export var furniture_type: Furniture.Type


func _get_impl():
	var impl := Furniture.new(furniture_type, size)

	return impl
