@tool
extends MapBuilderItem

@export var type: Furniture.Type


func _get_impl():
	var impl := Furniture.new(size)
	impl.type = type

	return impl
