@tool
extends MapBuilderItemCreator

@export var furniture_type: Furniture.Type
@export var material: FlammableMaterial


func _get_impl():
	var impl := Furniture.new(furniture_type, size)
	impl.material = material

	return impl
